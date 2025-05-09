import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/create_appointment/controllers/create_appointment_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custombis_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/widgets/document_scanner_widget.dart';

class CreateAppointmentView extends GetView<CreateAppointmentController> {
  const CreateAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);
    final isLoading = false.obs;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Nouveau Rendez-vous", style: TextStyle(color: AppColors.text)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const Text("Scanner ou importer le document", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),

              DocumentScannerWidget(
                scanType: 'combined',
                onExtracted: (data) {
                  controller.syncFormWithData(data);
                },
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text("Informations du véhicule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),

              CustomInput(
                hintText: "VIN du véhicule",
                icon: Icons.directions_car,
                controller: controller.vinController,
                onChanged: (val) => controller.vin.value = val,
              ),
              const SizedBox(height: 12),

              CustomInput(
                hintText: "Type de véhicule",
                icon: Icons.directions_bus,
                controller: controller.vehicleTypeController,
                onChanged: (val) => controller.vehicleType.value = val,
              ),
              const SizedBox(height: 12),

              CustomInput(
                hintText: "Numéro du titre",
                icon: Icons.confirmation_number_outlined,
                controller: controller.titleNumberController,
                onChanged: (val) => controller.titleNumber.value = val,
              ),

              const SizedBox(height: 24),

              Obx(() => CustomButton(
                text: isLoading.value ? "Chargement..." : "Créer le rendez-vous",
                onTap: () {
                  if (isLoading.value) return;
                  isLoading.value = true;
                  controller.proceedAfterVehicleForm();
                  isLoading.value = false;
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
