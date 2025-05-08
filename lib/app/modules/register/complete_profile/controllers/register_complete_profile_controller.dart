import 'package:get/get.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/user_service.dart';


class CompleteProfileController extends GetxController {
  final phone = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  final _userService = UserService();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  bool validate(String phone, String password, String confirmPassword) {
    final context = Get.context!;
    if (phone.isEmpty || phone.length < 6) {
      CustomToast.showError(context, "Numéro invalide");
      return false;
    }
    if (password.length < 6) {
      CustomToast.showError(context, "Mot de passe trop court");
      return false;
    }
    if (password != confirmPassword) {
      CustomToast.showError(context, "Les mots de passe ne correspondent pas");
      return false;
    }
    return true;
  }

  Future<void> submit(Map<String, dynamic> googleData) async {
    final context = Get.context!;
    if (!validate(phone.value, password.value, confirmPassword.value)) return;

    isLoading.value = true;

    try {
      final response = await _userService.createUser(
        firstName: googleData['firstName'],
        lastName: googleData['lastName'],
        email: googleData['email'],
        phone: phone.value,
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
      CustomToast.showError(context, "Erreur : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
