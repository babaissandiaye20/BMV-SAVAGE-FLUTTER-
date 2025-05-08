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

  bool validateForm({
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    final context = Get.context!;

    if (phone.isEmpty || phone.length < 6) {
      CustomToast.showError(context, "Numéro de téléphone invalide");
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      CustomToast.showError(context, "Mot de passe trop court");
      return false;
    }

    if (password != confirmPassword) {
      CustomToast.showError(context, "Les mots de passe ne correspondent pas");
      return false;
    }

    return true;
  }

  Future<void> register() async {
    final context = Get.context!;

    if (!validateForm(
      phone: phone.value.trim(),
      password: password.value,
      confirmPassword: confirmPassword.value,
    )) return;

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
        Get.offAllNamed(Routes.LOGIN);
      } else {
        final errors = response['errors'] ?? [];
        if (errors.isNotEmpty) {
          CustomToast.showError(context, errors.first.toString());
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
      // 1. Lancer la connexion Google
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      // 2. Récupérer les tokens d’authentification
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Connexion Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 4. Extraire nom, prénom et email depuis Google
      final displayName = googleUser.displayName ?? '';
      final parts = displayName.trim().split(' ');
      final firstName = parts.isNotEmpty ? parts[0] : '';
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      final email = googleUser.email;

      // 5. Attendre une frame pour éviter les soucis de navigation
      await Future.delayed(Duration.zero);

      // 6. Redirection vers la page complete_profile
      Get.toNamed(
        Routes.REGISTER_COMPLETE_PROFILE,
        arguments: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        },
      );
    } catch (e) {
      CustomToast.showError(context, "Échec de l'inscription via Google : $e");
    }
  }

}
