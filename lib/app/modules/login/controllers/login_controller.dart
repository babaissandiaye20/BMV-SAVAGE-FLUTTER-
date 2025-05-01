import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var obscurePassword = true.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    final context = Get.context!;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      CustomToast.showSuccess(context, 'Connexion réussie');
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomToast.showError(context, 'Identifiants invalides');
    }
  }

  Future<void> signInWithGoogle() async {
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
      CustomToast.showSuccess(context, 'Connexion via Google réussie');
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomToast.showError(context, 'Échec de la connexion Google');
    }
  }
}
