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

    InputDecoration customInputDecoration(String hintText) {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
      );
    }

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

              const SizedBox(height: 25),

              // Row pour First Name & Last Name
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.nom.value = value,
                      decoration: customInputDecoration('First Name'),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.prenom.value = value,
                      decoration: customInputDecoration('Last Name'),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Email
              CustomInput(
                hintText: 'Email',
                icon: Icons.email_outlined,
                onChanged: (value) => controller.email.value = value,
                fillColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.black54,
                borderColor: Colors.black,
                iconColor: Colors.black54,
              ),

              // Téléphone
              CustomInput(
                hintText: 'Téléphone',
                icon: Icons.phone_outlined,
                onChanged: (value) => controller.phone.value = value,
                fillColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.black54,
                borderColor: Colors.black,
                iconColor: Colors.black54,
              ),

              // Password
              Obx(() => CustomInput(
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) => controller.password.value = value,
                fillColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.black54,
                borderColor: Colors.black,
                iconColor: Colors.black54,
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

              // Confirm Password
              Obx(() => CustomInput(
                hintText: 'Confirm password',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) =>
                controller.confirmPassword.value = value,
                fillColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.black54,
                borderColor: Colors.black,
                iconColor: Colors.black54,
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

              // Sign Up
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

              const Center(
                child: Text("or", style: TextStyle(color: AppColors.text)),
              ),

              const SizedBox(height: 16),

              // Google Sign Up
              Obx(() => CustomButton(
                text: isGoogleLoading.value
                    ? "Connexion en cours..."
                    : "Sign up with Google",
                backgroundColor: AppColors.white,
                textColor: AppColors.text,
                borderColor: Colors.black,
                imageAsset: 'assets/images/google.png',
                onTap: () {
                  if (isGoogleLoading.value) return;
                  isGoogleLoading.value = true;
                  controller
                      .signUpWithGoogle()
                      .whenComplete(() => isGoogleLoading.value = false);
                },
              )),

              const SizedBox(height: 16),

              // Continue as guest
              CustomButton(
                text: "Continue as guest",
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onTap: () {
                  // Action invité
                },
              ),

              const SizedBox(height: 32),

              // Sign in link
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
