import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/services/otp_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
        (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final OtpService otpService = OtpService();

  late final String userId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['userId'] != null) {
      userId = args['userId'];
    } else {
      CustomToast.showError(Get.context!, 'ID utilisateur introuvable');
      Get.back(); // retourne à la page précédente si l'ID est manquant
    }
  }

  void onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final context = Get.context!;
    final code = otpControllers.map((c) => c.text).join();

    if (code.length != 6) {
      CustomToast.showError(context, "Veuillez entrer les 6 chiffres du code OTP");
      return;
    }

    try {
      await otpService.verifyOtp(userId, code);
      CustomToast.showSuccess(context, 'Numéro vérifié avec succès');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      CustomToast.showError(context, e.toString());
    }
  }

  Future<void> resendCode() async {
    try {
      await otpService.resendOtp(userId);
      CustomToast.showSuccess(Get.context!, 'Code renvoyé avec succès');
    } catch (e) {
      CustomToast.showError(Get.context!, 'Échec du renvoi: ${e.toString()}');
    }
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
