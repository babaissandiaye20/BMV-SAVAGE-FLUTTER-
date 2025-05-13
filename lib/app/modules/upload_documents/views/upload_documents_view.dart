import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salvage_app/app/modules/upload_documents/controllers/upload_documents_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upload_card.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class UploadDocumentsView extends StatelessWidget {
  const UploadDocumentsView({Key? key}) : super(key: key);

  void _showPicker(BuildContext context, String type, UploadDocumentsController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Get.back();
                controller.pickDocument(type, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Get.back();
                controller.pickDocument(type, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadDocumentsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Your Documents'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          const Center(
            child: Text(
              'Upload Your\nDocuments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 24),

          UploadCard(
            icon: Icons.badge,
            title: 'Driver’s License',
            isValid: controller.isLicenseValid.value,
            isLoading: controller.isLicenseLoading.value,
            errorMessage: controller.licenseError.value,
            onTap: () => _showPicker(context, 'license', controller),
          ),

          UploadCard(
            icon: Icons.directions_car,
            title: 'Car Title',
            isValid: controller.isTitleValid.value,
            isLoading: controller.isTitleLoading.value,
            errorMessage: controller.titleError.value,
            onTap: () => _showPicker(context, 'title', controller),
          ),

          UploadCard(
            icon: Icons.receipt_long,
            title: 'Inspection Receipt (Optionnel)',
            isValid: controller.isReceiptValid.value,
            isLoading: controller.isReceiptLoading.value,
            errorMessage: controller.receiptError.value,
            onTap: () => _showPicker(context, 'receipt', controller),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              if (controller.isReadyForPayment) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: controller.saveAppointmentOnly,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('VOILÀ', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.goToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Pay Now', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),

                  ],
                );
              } else {
                return const Text(
                  'Veuillez uploader et valider votre permis et titre.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                );
              }
            }),
          ),
        ],
      )),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
    );
  }
}
