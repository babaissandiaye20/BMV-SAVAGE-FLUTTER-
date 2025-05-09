/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salvage_app/app/modules/create_appointment/controllers/create_appointment_controller.dart';
import 'package:salvage_app/app/services/ocr_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class DocumentScannerWidget extends StatefulWidget {
  final String scanType; // 'license', 'title' ou 'combined'
  final void Function(Map<String, dynamic> data)? onExtracted;

  const DocumentScannerWidget({
    super.key,
    required this.scanType,
    this.onExtracted,
  });

  @override
  State<DocumentScannerWidget> createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  final ImagePicker _picker = ImagePicker();
  final OcrService _ocrService = OcrService();

  File? selectedImage;
  bool isLoading = false;

  Future<void> pickAndExtract(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      isLoading = true;
      selectedImage = File(picked.path);
    });

    try {
      final data = await _ocrService.processImage(
        picked.path,
        scanType: widget.scanType,
      );

      final controller = Get.find<CreateAppointmentController>();

      if (data.isEmpty || data['VIN'] == null) {
        CustomToast.showError(context, "Données recherchées non trouvées.");
      } else {
        controller.vin.value = data['VIN'] ?? '';
        controller.vehicleType.value = data['TYPE'] ?? '';
        controller.titleNumber.value = data['NUM_TITRE'] ?? '';
        controller.location.value = data['LIEU'] ?? '';
        controller.hasScanned.value = true;

        // Appel du callback si défini
        if (widget.onExtracted != null) {
          widget.onExtracted!(data);
        }
      }
    } catch (e) {
      CustomToast.showError(context, e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.scanType) {
      'license' => "Permis de conduire",
      'title' => "Carte grise",
      'combined' => "Document combiné",
      _ => "Document"
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(selectedImage!, height: 180, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickAndExtract(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Photo"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickAndExtract(ImageSource.gallery),
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Fichier"),
                  ),
                ),
              ],
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
*/
