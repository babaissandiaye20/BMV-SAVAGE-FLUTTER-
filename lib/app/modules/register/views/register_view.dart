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
              const SizedBox(height: 20),

              // Logo
              Center(
                child: Image.asset('assets/images/landing.png', height: 90),
              ),

              const SizedBox(height: 24),

              // Titre
              const Center(
                child: Text(
                  'Create Account now',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Champs de formulaire stylisés en noir
              CustomInput(
                hintText: 'First Name',
                icon: Icons.person_outline,
                onChanged: (value) => controller.nom.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
              ),
              CustomInput(
                hintText: 'Last Name',
                icon: Icons.person_outline,
                onChanged: (value) => controller.prenom.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
              ),
              CustomInput(
                hintText: 'Email',
                icon: Icons.email_outlined,
                onChanged: (value) => controller.email.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
              ),
              CustomInput(
                hintText: 'Téléphone',
                icon: Icons.phone_outlined,
                onChanged: (value) => controller.phone.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
              ),

              // Mot de passe
              Obx(() => CustomInput(
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) => controller.password.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
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
                hintText: 'Confirm password',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) =>
                controller.confirmPassword.value = value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                borderColor: AppColors.borderColor,
                iconColor: AppColors.inputHint,
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

              // Bouton Sign Up rouge
              Obx(() => CustomButton(
                text: isLoading.value ? "Chargement..." : "Sign Up",
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
                onTap: () {
                  if (isLoading.value) return;
                  isLoading.value = true;
                  controller
                      .register()
                      .whenComplete(() => isLoading.value = false);
                },
              )),

              const SizedBox(height: 16),

              // Texte séparateur
              const Center(
                child: Text(
                  "or",
                  style: TextStyle(color: AppColors.text),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Google
              Obx(() => CustomButton(
                text: isGoogleLoading.value
                    ? "Connexion en cours..."
                    : "Sign up with Google",
                backgroundColor: AppColors.white,
                textColor: AppColors.text,
                borderColor: AppColors.borderColor,
                imageAsset: 'assets/images/google.png',
                onTap: () {
                  if (isGoogleLoading.value) return;
                  isGoogleLoading.value = true;
                  controller
                      .signUpWithGoogle()
                      .whenComplete(() => isGoogleLoading.value = false);
                },
              )),

              const SizedBox(height: 32),

              // Lien vers page de connexion
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Sign in",
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
