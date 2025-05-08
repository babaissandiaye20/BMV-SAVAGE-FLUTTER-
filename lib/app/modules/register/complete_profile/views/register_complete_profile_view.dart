import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/widgets/custom_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

import '../../../../widgets/custom_toast.dart';
import '../controllers/register_complete_profile_controller.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Sécurisé contre les arguments nuls
    final googleData = (Get.arguments ?? {}) as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Compléter votre profil"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            CustomInput(
              hintText: 'Numéro de téléphone',
              icon: Icons.phone,
              onChanged: (val) => controller.phone.value = val.trim(),
            ),
            const SizedBox(height: 16),
            Obx(() => CustomInput(
              hintText: 'Mot de passe',
              icon: Icons.lock_outline,
              obscureText: controller.obscurePassword.value,
              onChanged: (val) => controller.password.value = val,
              suffixIcon: GestureDetector(
                onTap: controller.togglePasswordVisibility,
                child: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            )),
            const SizedBox(height: 16),
            Obx(() => CustomInput(
              hintText: 'Confirmer le mot de passe',
              icon: Icons.lock_outline,
              obscureText: controller.obscureConfirmPassword.value,
              onChanged: (val) => controller.confirmPassword.value = val,
              suffixIcon: GestureDetector(
                onTap: controller.toggleConfirmPasswordVisibility,
                child: Icon(
                  controller.obscureConfirmPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            )),
            const SizedBox(height: 24),
            Obx(() => CustomButton(
              text: controller.isLoading.value ? "Chargement..." : "Valider",
              onTap: () {
                if (controller.isLoading.value) return;

                if (googleData['email'] == null || googleData['firstName'] == null) {
                  CustomToast.showError(context, "Données Google manquantes.");
                  return;
                }

                controller.submit(googleData);
              },
            )),
          ],
        ),
      ),
    );
  }
}
