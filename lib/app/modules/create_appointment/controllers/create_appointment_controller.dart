import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class CreateAppointmentController extends GetxController {
  final vin = ''.obs;
  final vehicleType = ''.obs;
  final titleNumber = ''.obs;
  final location = ''.obs;
  final scheduledAt = ''.obs;

  final vinController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final titleNumberController = TextEditingController();
  final locationController = TextEditingController();
  final hasScanned = false.obs;

  final AppointmentService _appointmentService = AppointmentService();
  final double fixedAmount = 99.99;

  void syncFormWithData(Map<String, dynamic> data) {
    print("📦 Données reçues dans syncFormWithData : $data");

    // Mapping robuste des clés
    final normalizedData = {
      'VIN': data['VIN']?.toString().trim(),
      'VehicleType': data['VehicleType']?.toString().trim() ?? data['Vehicle Type']?.toString().trim(),
      'TitleNumber': data['TitleNumber']?.toString().trim() ?? data['Title Number']?.toString().trim(),
      'Location': data['Location']?.toString().trim(),
    };

    vin.value = normalizedData['VIN'] ?? '';
    vehicleType.value = normalizedData['VehicleType'] ?? '';
    titleNumber.value = normalizedData['TitleNumber'] ?? '';
    location.value = normalizedData['Location'] ?? '';

    vinController.text = vin.value;
    vehicleTypeController.text = vehicleType.value;
    titleNumberController.text = titleNumber.value;
    locationController.text = location.value;
  }


  @override
  void onClose() {
    vinController.dispose();
    vehicleTypeController.dispose();
    titleNumberController.dispose();
    locationController.dispose();
    super.onClose();
  }

  Future<void> createAppointment() async {
    final context = Get.context!;
    final userId = await SecureStorageService.readUserId();
    final token = await SecureStorageService.readToken();

    if (userId == null || token == null) {
      CustomToast.showError(context, "Utilisateur non authentifié.");
      return;
    }

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
        token: token,
      );

      if (response['status'] == 'success') {
        CustomToast.showSuccess(context, "Rendez-vous créé avec succès.");
        final appointmentId = response['data']['id'];
        if (appointmentId == null) {
          CustomToast.showError(context, "ID de rendez-vous manquant.");
          return;
        }

        Get.toNamed('/payment', arguments: {
          'appointmentId': appointmentId,
          'amount': fixedAmount,
        });
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
