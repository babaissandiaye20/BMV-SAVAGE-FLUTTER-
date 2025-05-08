import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:salvage_app/app/services/payment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class PaymentController extends GetxController {
  var paymentModes = <Map<String, dynamic>>[].obs;
  var selectedModeId = ''.obs;
  var isLoading = false.obs;
  var isTestMode = false.obs;

  String appointmentId = '';
  double amount = 0;
  final currency = 'usd';

  CardFieldInputDetails? cardDetails;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null || args['appointmentId'] == null || args['amount'] == null) {
      CustomToast.showError(Get.context!, 'Données de paiement manquantes.');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back();
      });
      return;
    }

    appointmentId = args['appointmentId'].toString();
    amount = double.tryParse(args['amount'].toString()) ?? 0.0;

    fetchModes();
  }

  Future<void> fetchModes() async {
    try {
      isLoading.value = true;
      final modes = await PaymentService.fetchPaymentModes();
      paymentModes.assignAll(modes);
      if (modes.isNotEmpty) selectedModeId.value = modes.first['id'];
    } catch (e) {
      CustomToast.showError(Get.context!, 'Erreur chargement modes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pay() async {
    final context = Get.context!;
    try {
      isLoading.value = true;

      if (Stripe.publishableKey.isEmpty) {
        throw Exception("Stripe n'est pas correctement initialisé");
      }

      if (cardDetails == null || !(cardDetails!.complete ?? false)) {
        throw Exception("Les informations de carte ne sont pas complètes");
      }

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: 'test@example.com',
            ),
          ),
        ),
      );

      final userId = await SecureStorageService.readUserId();
      if (userId == null) {
        CustomToast.showError(context, "Utilisateur non authentifié.");
        return;
      }

      await PaymentService.createPayment(
        userId: userId,
        appointmentId: appointmentId,
        paymentModeId: selectedModeId.value,
        amount: amount,
        currency: currency,
        paymentMethodId: paymentMethod.id,
      );

      CustomToast.showSuccess(context, 'Paiement réussi');
      Get.offAllNamed('/home');
    } catch (e) {
      String errorMessage = 'Échec du paiement';
      if (e is StripeException) {
        errorMessage = 'Erreur Stripe: ${e.error.localizedMessage ?? e.error.message}';
      } else {
        errorMessage = 'Erreur: $e';
      }
      CustomToast.showError(context, errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
