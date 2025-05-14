import 'package:get/get.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';

import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();

  Future<void> logoutUser() async {
    try {
      final token = await SecureStorageService.readToken();
      if (token != null) {
        await _authService.logout(token);
      }

      await SecureStorageService.clearAll();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur lors de la déconnexion");
    }
  }
}
