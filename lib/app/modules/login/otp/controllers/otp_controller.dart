import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/routes/app_pages.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  void onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp() {
    final code = otpControllers.map((c) => c.text).join();
    if (code.length == 6) {
      print("Code OTP : $code");
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar("Erreur", "Veuillez entrer les 6 chiffres du code OTP");
    }
  }

  void resendCode() {
    print("Renvoi du code OTP");
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
