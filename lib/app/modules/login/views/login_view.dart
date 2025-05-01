import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/login/controllers/login_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_input.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

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
                child: Image.asset('assets/images/logorb.png', height: 100),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Ohio Vehicle Inspection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomInput(
                hintText: 'Email',
                icon: Icons.email_outlined,
                onChanged: (value) => controller.email.value = value,
              ),
              Obx(
                () => CustomInput(
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
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(text: "Se connecter", onTap: controller.login),
              const SizedBox(height: 16),
              CustomButton(
                text: "Se connecter avec Google",
                backgroundColor: AppColors.white,
                textColor: AppColors.text,
                borderColor: AppColors.inputBorder,
                imageAsset: 'assets/images/google.png',
                onTap: controller.signInWithGoogle,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Vous n'avez pas de compte ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "S'inscrire",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // À implémenter plus tard
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
