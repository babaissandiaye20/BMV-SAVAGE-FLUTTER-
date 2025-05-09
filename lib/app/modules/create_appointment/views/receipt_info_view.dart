import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/create_appointment/controllers/create_appointment_controller.dart';
import 'package:salvage_app/app/widgets/custombis_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/document_scanner_widget.dart';

class ReceiptInfoView extends StatelessWidget {
  ReceiptInfoView({super.key});

  final CreateAppointmentController controller = Get.find<CreateAppointmentController>();

  @override
  Widget build(BuildContext context) {
    final isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(title: const Text("Informations du reçu")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text("Scanner ou importer le reçu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),

            DocumentScannerWidget(
              scanType: 'receipt',
              onExtracted: (data) {
                final receipt = controller.extractValue(data, [
                  'ReceiptNumber',
                  'Receipt No',
                  'receipt_number',
                  'receipt no',
                ]);

                final date = controller.extractValue(data, [
                  'IssuesDate',
                  'Issue Date',
                  'issue_date',
                ]);

                controller.receiptNumber.value = receipt;
                controller.issuesDate.value = date;

                controller.receiptNumberController.text = receipt;
                controller.issuesDateController.text = date;
              },
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            const Text("Ou saisir manuellement :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            CustomInput(
              hintText: "Numéro du reçu",
              icon: Icons.receipt,
              controller: controller.receiptNumberController,
              onChanged: (val) => controller.receiptNumber.value = val,
            ),
            const SizedBox(height: 12),

            CustomInput(
              hintText: "Date d’émission (JJ/MM/AAAA)",
              icon: Icons.date_range,
              controller: controller.issuesDateController,
              onChanged: (val) => controller.issuesDate.value = val,
            ),
            const SizedBox(height: 24),

            Obx(() => CustomButton(
              text: isLoading.value ? "Création en cours..." : "Créer le rendez-vous",
              onTap: () {
                if (isLoading.value) return;
                isLoading.value = true;

                controller.createAppointment().whenComplete(() {
                  isLoading.value = false;
                });
              },
            )),
          ],
        ),
      ),
    );
  }
}
