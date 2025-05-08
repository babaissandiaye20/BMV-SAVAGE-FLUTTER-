import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/register/controllers/register_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);

    final isLoading = false.obs;
    final isGoogleLoading = false.obs;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset('assets/images/logorb.png', height: 100),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomInput(
                hintText: 'Nom',
                icon: Icons.person_outline,
                onChanged: (value) => controller.nom.value = value,
              ),
              CustomInput(
                hintText: 'Prénom',
                icon: Icons.person_outline,
                onChanged: (value) => controller.prenom.value = value,
              ),
              CustomInput(
                hintText: 'Email',
                icon: Icons.email_outlined,
                onChanged: (value) => controller.email.value = value,
              ),
              CustomInput(
                hintText: 'Téléphone',
                icon: Icons.phone_outlined,
                onChanged: (value) => controller.phone.value = value,
              ),
              Obx(() => CustomInput(
                hintText: 'Mot de passe',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) => controller.password.value = value,
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
              Obx(() => CustomInput(
                hintText: 'Confirmer le mot de passe',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) =>
                controller.confirmPassword.value = value,
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
              const SizedBox(height: 24),
              Obx(() => CustomButton(
                text: isLoading.value ? "Chargement..." : "S'inscrire",
                onTap: () {
                  if (isLoading.value) return;
                  isLoading.value = true;
                  controller
                      .register()
                      .whenComplete(() => isLoading.value = false);
                },
              )),
              const SizedBox(height: 16),
              Obx(() => CustomButton(
                text: isGoogleLoading.value
                    ? "Connexion en cours..."
                    : "S'inscrire avec Google",
                backgroundColor: AppColors.white,
                textColor: AppColors.text,
                borderColor: AppColors.inputBorder,
                imageAsset: 'assets/images/google.png',
                onTap: () {
                  if (isGoogleLoading.value) return;
                  isGoogleLoading.value = true;
                  controller
                      .signUpWithGoogle()
                      .whenComplete(() => isGoogleLoading.value = false);
                },
              )),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Vous avez déjà un compte ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Se connecter",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
