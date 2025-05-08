import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import '../controllers/upload_documents_controller.dart';
import '../../../widgets/document_scannerbis_widget.dart';

class UploadDocumentsView extends GetView<UploadDocumentsController> {
  const UploadDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan des documents"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DocumentScannerWidget(scanType: 'license'),
              const SizedBox(height: 16),
              DocumentScannerWidget(scanType: 'title'),
              const SizedBox(height: 24),
              CustomButton(
                text: "Passer au rendez-vous",
                onTap: () => Get.toNamed('/create-appointment'),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
