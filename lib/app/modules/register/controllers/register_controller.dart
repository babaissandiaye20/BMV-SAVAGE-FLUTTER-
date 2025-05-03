import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

import '../../../services/user_service.dart';


class RegisterController extends GetxController {
  var nom = ''.obs;
  var prenom = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var obscurePassword = true.obs;

  final UserService _userService = UserService();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> register() async {
    final context = Get.context!;
    if (password.value != confirmPassword.value) {
      CustomToast.showError(context, "Les mots de passe ne correspondent pas");
      return;
    }

    try {
      final response = await _userService.createUser(
        firstName: prenom.value.trim(),
        lastName: nom.value.trim(),
        email: email.value.trim(),
        phone: phone.value.trim(),
        password: password.value,
      );

      if (response['status'] == 'success') {
        CustomToast.showSuccess(context, "Inscription réussie");
        Get.offAllNamed('/login');
      } else {
        final List errors = response['errors'] ?? [];
        if (errors.isNotEmpty) {
          CustomToast.showError(context, errors.first.toString()); // Affiche la première erreur
        } else {
          CustomToast.showError(context, response['message'] ?? "Erreur inconnue");
        }
      }
    } catch (e) {
      CustomToast.showError(context, "Erreur de création : $e");
    }
  }

  Future<void> signUpWithGoogle() async {
    final context = Get.context!;
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      CustomToast.showSuccess(context, 'Inscription via Google réussie');
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomToast.showError(context, 'Échec de l\'inscription Google');
    }
  }
}
