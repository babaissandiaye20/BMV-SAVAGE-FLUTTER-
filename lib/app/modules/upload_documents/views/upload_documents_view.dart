import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import '../controllers/upload_documents_controller.dart';

class UploadDocumentsView extends GetView<UploadDocumentsController> {
  const UploadDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Téléversement des documents"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => SingleChildScrollView( // Utiliser SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildCard(
                title: "Permis de conduire",
                file: controller.licenseFile.value,
                onScan: () => controller.pickDocument('license', ImageSource.camera),
                onUpload: () => controller.pickDocument('license', ImageSource.gallery),
                onClear: () => controller.clearDocument('license'),
              ),
              const SizedBox(height: 24),
              _buildCard(
                title: "Carte grise",
                file: controller.titleFile.value,
                onScan: () => controller.pickDocument('title', ImageSource.camera),
                onUpload: () => controller.pickDocument('title', ImageSource.gallery),
                onClear: () => controller.clearDocument('title'),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Continuer",
                onTap: () {
                  if (controller.hasAtLeastOne) {
                    final msg = [
                      if (controller.licenseFile.value != null) "✔️ Permis"
                      else "❌ Permis",
                      if (controller.titleFile.value != null) "✔️ Carte grise"
                      else "❌ Carte grise",
                    ].join(" | ");
                    CustomToast.showSuccess(context, "Documents : $msg");
                    // TODO: Naviguer vers la page de rendez-vous
                  } else {
                    CustomToast.showError(context, "Veuillez sélectionner au moins un document.");
                  }
                },
                backgroundColor: controller.hasAtLeastOne
                    ? AppColors.primary
                    : AppColors.inputBorder,
                textColor: controller.hasAtLeastOne
                    ? Colors.white
                    : Colors.grey,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required XFile? file,
    required VoidCallback onScan,
    required VoidCallback onUpload,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (file != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(file.path),
                    height: 220, // Limitation de la hauteur de l'image
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onClear,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            )
          else
            const Text("Aucun document sélectionné", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Téléverser"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
