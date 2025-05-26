import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/models/appointment_response.dart';
import 'package:salvage_app/app/models/payment_mode_response.dart';

import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/services/payment_mode_service.dart';
import 'package:salvage_app/app/services/payment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


import '../../../models/payment_response.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/payment_success_view.dart';

class PaymentController extends GetxController {
  final AppointmentService _appointmentService = AppointmentService();
  final PaymentModeService _paymentModeService = PaymentModeService();
  final PaymentService _paymentService = PaymentService();

  var appointments = <AppointmentRequest>[].obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;

  var paymentModes = <PaymentMode>[].obs;
  var selectedPaymentMode = Rxn<PaymentMode>();

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
    fetchPaymentModes();
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    try {
      final token = await SecureStorageService.readToken();
      final userId = await SecureStorageService.readUserId();

      if (token == null || userId == null) {
        CustomToast.showError(Get.context!, "Utilisateur non authentifié.");
        return;
      }

      final data = await _appointmentService.getPendingAppointmentsWithoutPayment(
        userId: userId,
        token: token,
      );

      final results = data['data'] as List<dynamic>;

      appointments.assignAll(results.map((e) {
        final appt = AppointmentRequest.fromJson(e);
        final base = 30.0;
        final extra = (appt.receiptNumber?.isNotEmpty ?? false) ? 0.0 : 10.0;
        appt.setPrice(base + extra);
        return appt;
      }).toList());

      calculateTotal();
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur de chargement des rendez-vous: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotal() {
    double sum = 0;
    for (var a in appointments) {
      sum += a.price ?? 0;
    }
    totalAmount.value = sum;
  }

  Future<void> fetchPaymentModes() async {
    try {
      final token = await SecureStorageService.readToken();
      if (token == null) return;

      final modes = await _paymentModeService.getAllPaymentModes(token: token);
      paymentModes.assignAll(modes);
      if (modes.isNotEmpty) {
        selectedPaymentMode.value = modes.first;
      }
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur chargement modes de paiement.");
    }
  }

  Future<void> initiateStripePayment() async {
    final token = await SecureStorageService.readToken();
    final userId = await SecureStorageService.readUserId();
    final paymentMode = selectedPaymentMode.value;

    if (token == null || userId == null || paymentMode == null) {
      CustomToast.showError(Get.context!, "Paiement impossible, infos manquantes.");
      return;
    }

    final request = PaymentRequestResponse(
      userId: userId,
      appointmentIds: appointments.map((e) => e.id).toList(), // ✅ plus de `!`
      paymentModeId: paymentMode.id,
      amounts: appointments.map((e) => e.price ?? 0.0).toList(),
      currency: 'usd',
    );


    try {
      final response = await _paymentService.createCheckoutSession(
        token: token,
        request: request,
      );

      if (response.checkoutUrl != null) {
        await launchUrl(Uri.parse(response.checkoutUrl!), mode: LaunchMode.externalApplication);
      } else {
        CustomToast.showError(Get.context!, "Aucune URL de paiement reçue.");
      }
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur paiement: $e");
    }
  }
  Future<void> deleteAppointment(String appointmentId) async {
    final token = await SecureStorageService.readToken();
    if (token == null) {
      CustomToast.showError(Get.context!, "Utilisateur non authentifié.");
      return;
    }
    final confirmed = await showDialog<bool>(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Voulez-vous vraiment supprimer ce rendez-vous ?"),
        actions: [
          TextButton(child: const Text("Annuler"), onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(child: const Text("Confirmer"), onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _appointmentService.cancelAppointment(
          appointmentId: appointmentId,
          token: token,
        );
        appointments.removeWhere((a) => a.id == appointmentId);
        calculateTotal();
        CustomToast.showSuccess(Get.context!, "Rendez-vous supprimé.");
      } catch (e) {
        CustomToast.showError(Get.context!, "Erreur suppression : $e");
      }
    }
  }
  Future<void> payWithStripeIntent() async {
    final token = await SecureStorageService.readToken();
    final userId = await SecureStorageService.readUserId();
    final paymentMode = selectedPaymentMode.value;

    if (token == null || userId == null || paymentMode == null) {
      CustomToast.showError(Get.context!, "Paiement impossible, infos manquantes.");
      return;
    }

    final request = PaymentRequestResponse(
      userId: userId,
      appointmentIds: appointments.map((e) => e.id).toList(),
      paymentModeId: paymentMode.id,
      amounts: appointments.map((e) => e.price ?? 0.0).toList(),
      currency: 'usd',
    );

    // ✅ Affiche le loader pendant l’initiation
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. Création du PaymentIntent côté backend
      final response = await _paymentService.createPaymentIntent(
        token: token,
        request: request,
      );
      final clientSecret = response.clientSecret;

      // 2. Initialisation de la feuille de paiement Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Salvage App',
          style: ThemeMode.light,
          allowsDelayedPaymentMethods: false,
        ),
      );

      // Ferme le loader avant d'afficher la feuille de paiement
      Get.back();

      // 3. Présentation de la feuille de paiement
      await Stripe.instance.presentPaymentSheet();

      // 4. Paiement réussi
      CustomToast.showSuccess(Get.context!, "Paiement effectué avec succès.");

      // Recharge des rendez-vous
      await fetchAppointments();

      // 5. Affiche le widget de confirmation
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => const PaymentSuccessView (),
      );

    } on StripeException catch (_) {
      Get.back(); // Ferme le loader si erreur Stripe
      CustomToast.showError(Get.context!, "Paiement annulé ou refusé.");
    } catch (e) {
      Get.back(); // Ferme le loader si erreur
      CustomToast.showError(Get.context!, "Erreur inattendue : $e");
    }
  }


}
