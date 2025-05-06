import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';

class CreateAppointmentController extends GetxController {
  final vin = ''.obs;
  final vehicleType = ''.obs;
  final titleNumber = ''.obs;
  final location = ''.obs;
  final scheduledAt = ''.obs;

  final AppointmentService _appointmentService = AppointmentService();

  Future<void> createAppointment() async {
    final context = Get.context!;
    final userId = await SecureStorageService.readUserId();

    if (userId == null) {
      CustomToast.showError(context, "Utilisateur non authentifié.");
      return;
    }

    // Simple validation
    if (vin.value.isEmpty ||
        vehicleType.value.isEmpty ||
        titleNumber.value.isEmpty ||
        location.value.isEmpty ||
        scheduledAt.value.isEmpty) {
      CustomToast.showError(context, "Tous les champs sont obligatoires.");
      return;
    }

    try {
      final response = await _appointmentService.createAppointment(
        userId: userId,
        vin: vin.value.trim(),
        vehicleType: vehicleType.value.trim(),
        titleNumber: titleNumber.value.trim(),
        scheduledAt: scheduledAt.value.trim(),
        location: location.value.trim(),
      );

      if (response['status'] == 'success') {
        CustomToast.showSuccess(context, "Rendez-vous créé avec succès.");
        Get.back(); // Retour à la page précédente (Home ou autre)
      } else {
        final errors = response['errors'] ?? [];
        if (errors.isNotEmpty) {
          CustomToast.showError(context, errors.first.toString());
        } else {
          CustomToast.showError(context, response['message'] ?? "Erreur inconnue");
        }
      }
    } catch (e) {
      CustomToast.showError(context, "Erreur lors de la création : $e");
    }
  }
}
