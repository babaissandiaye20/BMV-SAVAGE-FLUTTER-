/*
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salvage_app/app/services/document_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/modules/create_appointment/controllers/create_appointment_controller.dart';

import '../../../services/ocr_service.dart';


class UploadDocumentsController extends GetxController {
  Rxn<XFile> licenseFile = Rxn<XFile>();
  Rxn<XFile> titleFile = Rxn<XFile>();
  RxBool isLoading = false.obs;

  final picker = ImagePicker();
  final DocumentService _service = DocumentService();
  final OcrService _ocrService = OcrService();

  void pickDocument(String type, ImageSource source) async {
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      if (type == 'license') {
        licenseFile.value = picked;
      } else if (type == 'title') {
        titleFile.value = picked;
      }
    }
  }

  void clearDocument(String type) {
    if (type == 'license') {
      licenseFile.value = null;
    } else if (type == 'title') {
      titleFile.value = null;
    }
  }

  bool get hasAtLeastOne =>
      licenseFile.value != null || titleFile.value != null;

  Future<void> uploadDocuments() async {
    if (!hasAtLeastOne) return;

    isLoading.value = true;
    try {
      if (licenseFile.value != null) {
        await _service.uploadDocument(File(licenseFile.value!.path), 'LICENSE');
      }
      if (titleFile.value != null) {
        await _service.uploadDocument(File(titleFile.value!.path), 'TITLE');
      }

      CustomToast.showSuccess(Get.context!, "Documents envoyés avec succès");
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur : ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> extractAndPrefillAppointmentData() async {
    final appointmentController = Get.find<CreateAppointmentController>();

    try {
      if (titleFile.value != null) {
        final data = await _ocrService.processImage(
          titleFile.value!.path,
          scanType: 'title',
        );

        appointmentController.vin.value = data['VIN'] ?? '';
        appointmentController.vehicleType.value = data['TYPE'] ?? '';
        appointmentController.titleNumber.value = data['NUM_TITRE'] ?? '';
        appointmentController.location.value = data['LIEU'] ?? '';
      }

      if (licenseFile.value != null) {
        final data = await _ocrService.processImage(
          licenseFile.value!.path,
          scanType: 'license',
        );

        // Tu peux aussi stocker le nom du conducteur ou d'autres champs si besoin
      }
    } catch (e) {
      CustomToast.showError(Get.context!, "Échec de l'extraction OCR : $e");
    }
  }
}
*/
