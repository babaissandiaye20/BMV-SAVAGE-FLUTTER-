import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/login/controllers/login_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import '../../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset('assets/images/landing.png', height: 120),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Schedule your inspection easily —',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'Ohio BMV',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomInput(
                hintText: 'Email Address',
                icon: Icons.email_outlined,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                onChanged: (value) => controller.email.value = value,
              ),
              const SizedBox(height: 16),
              Obx(() => CustomInput(
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: controller.obscurePassword.value,
                fillColor: AppColors.inputBackground,
                textColor: AppColors.inputText,
                hintColor: AppColors.inputHint,
                onChanged: (value) => controller.password.value = value,
                suffixIcon: GestureDetector(
                  onTap: controller.togglePasswordVisibility,
                  child: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.inputHint,
                  ),
                ),
              )),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Sign in",
                onTap: controller.loginWithBackend,
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              ),
              const SizedBox(height: 16),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Create account',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(Routes.REGISTER);
                    },
                ),
              ),
            ),

              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: AppColors.secondary,
                  child: const Text(
                    "or",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Sign up with Google",
                imageAsset: 'assets/images/google.png',
                onTap: controller.signInWithGoogle,
                backgroundColor: AppColors.white,
                textColor: AppColors.text,
                borderColor: AppColors.secondary,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Continue as guest",
                backgroundColor: AppColors.secondary,
                textColor: AppColors.white,
                onTap: controller.continueAsGuest,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
