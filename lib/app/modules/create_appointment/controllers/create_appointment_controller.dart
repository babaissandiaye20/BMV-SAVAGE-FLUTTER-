import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import '../../../models/appointment_response.dart';
import '../../../widgets/custom_confirmation_modal.dart';

class CreateAppointmentController extends GetxController {
  final vin = ''.obs;
  final vehicleType = ''.obs;
  final titleNumber = ''.obs;
  final receiptNumber = ''.obs;
  final issuesDate = ''.obs;

  final vinController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final titleNumberController = TextEditingController();
  final receiptNumberController = TextEditingController();
  final issuesDateController = TextEditingController();

  final selectedReceiptOption = 'Oui'.obs;

  final AppointmentService _appointmentService = AppointmentService();
  final double fixedAmount = 99.99;

  void syncFormWithData(Map<String, dynamic> data) {
    vin.value = extractValue(data, ['VIN']);

    vehicleType.value = extractValue(data, [
      'VehicleType',
      'Vehicle Type',
      'type_de_vehicule',
      'type_de_vehicle',
    ]);

    titleNumber.value = extractValue(data, [
      'TitleNumber',
      'Title Number',
      'numero_de_titre',
    ]);

    receiptNumber.value = extractValue(data, [
      'ReceiptNumber',
      'Receipt No',
      'receipt_number',
      'receipt no',
    ]);

    issuesDate.value = extractValue(data, [
      'IssuesDate',
      'Issue Date',
      'issue_date',
    ]);

    vinController.text = vin.value;
    vehicleTypeController.text = vehicleType.value;
    titleNumberController.text = titleNumber.value;
    receiptNumberController.text = receiptNumber.value;
    issuesDateController.text = issuesDate.value;
  }

  Future<void> proceedAfterVehicleForm() async {
    final context = Get.context!;
    showDialog(
      context: context,
      builder: (_) => CustomConfirmationModal(
        title: "Reçu d’inspection",
        description: "Avez-vous un reçu d’inspection ?",
        radioOptions: ["Oui", "Non"],
        selectedOption: selectedReceiptOption.value,
        onRadioChanged: (val) => selectedReceiptOption.value = val ?? "Oui",
        onConfirm: () {
          Navigator.of(context).pop();
          if (selectedReceiptOption.value == "Oui") {
            Get.toNamed('/receipt-info');
          } else {
            createAppointment(withExtraFee: true);
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> createAppointment({bool withExtraFee = false}) async {
    final context = Get.context!;
    final userId = await SecureStorageService.readUserId();
    final token = await SecureStorageService.readToken();

    if (userId == null || token == null) {
      CustomToast.showError(context, "Utilisateur non authentifié.");
      return;
    }

    if (vin.value.isEmpty || vehicleType.value.isEmpty || titleNumber.value.isEmpty) {
      CustomToast.showError(context, "Les informations du véhicule sont incomplètes.");
      return;
    }

    final amountToPay = withExtraFee ? fixedAmount + 55 : fixedAmount;

    final request = AppointmentRequest(
      userId: userId,
      vin: vin.value.trim(),
      vehicleType: vehicleType.value.trim(),
      titleNumber: titleNumber.value.trim(),
      receiptNumber: receiptNumber.value.trim().isNotEmpty ? receiptNumber.value.trim() : null,
      issuesDate: issuesDate.value.trim().isNotEmpty ? issuesDate.value.trim() : null,
    );

    try {
      final response = await _appointmentService.createAppointment(
        request: request,
        token: token,
      );

      if (response['status'] == 'success') {
        final appointmentId = response['data']['id'];
        if (appointmentId == null) {
          CustomToast.showError(context, "ID de rendez-vous manquant.");
          return;
        }

        Get.toNamed('/payment', arguments: {
          'appointmentId': appointmentId,
          'amount': amountToPay,
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

  /// Utilitaire pour récupérer une valeur parmi plusieurs clés
  String extractValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      if (data.containsKey(key) &&
          data[key] != null &&
          data[key].toString().trim().isNotEmpty) {
        return data[key].toString().trim();
      }
    }
    return '';
  }
}
