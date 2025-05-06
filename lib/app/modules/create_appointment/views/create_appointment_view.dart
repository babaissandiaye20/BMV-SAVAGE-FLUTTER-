import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/create_appointment/controllers/create_appointment_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

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
              CustomInput(
                hintText: "VIN du véhicule",
                icon: Icons.directions_car,
                onChanged: (val) => controller.vin.value = val,
              ),
              CustomInput(
                hintText: "Type de véhicule",
                icon: Icons.directions_bus,
                onChanged: (val) => controller.vehicleType.value = val,
              ),
              CustomInput(
                hintText: "Numéro du titre",
                icon: Icons.confirmation_number_outlined,
                onChanged: (val) => controller.titleNumber.value = val,
              ),
              CustomInput(
                hintText: "Lieu du rendez-vous",
                icon: Icons.location_on_outlined,
                onChanged: (val) => controller.location.value = val,
              ),
              CustomInput(
                hintText: "Date & heure (ex: 2025-05-10T14:30:00)",
                icon: Icons.calendar_today,
                onChanged: (val) => controller.scheduledAt.value = val,
              ),
              const SizedBox(height: 24),
              Obx(() => CustomButton(
                text: isLoading.value ? "Chargement..." : "Créer le rendez-vous",
                onTap: () {
                  if (isLoading.value) return;
                  isLoading.value = true;
                  controller
                      .createAppointment()
                      .whenComplete(() => isLoading.value = false);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
