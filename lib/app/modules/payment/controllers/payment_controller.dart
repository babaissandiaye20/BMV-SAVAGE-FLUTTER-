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

  String appointmentId = '';
  double amount = 0;
  final currency = 'usd';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    appointmentId = args['appointmentId'];
    amount = args['amount'];
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
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: const PaymentMethodData(
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
      CustomToast.showError(context, 'Échec du paiement: $e');
    } finally {
      isLoading.value = false;
    }
  }
}