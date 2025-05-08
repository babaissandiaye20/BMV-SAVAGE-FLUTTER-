import 'package:get/get.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/services/auth_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart'; // ⬅️ Ajouté
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var obscurePassword = true.obs;

  var isGoogleSignInClicked = false.obs;

  final AuthService authService = AuthService();

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  // Connexion via Firebase (optionnel)
  Future<void> loginWithFirebase() async {
    final context = Get.context!;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      CustomToast.showSuccess(context, 'Connexion réussie');
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      String errorMessage = 'Erreur inconnue';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Problème de connexion';
      }
      CustomToast.showError(context, 'Identifiants invalides: $errorMessage');
    }
  }

  // Connexion via Google (optionnel)
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
      CustomToast.showError(context, 'Échec de la connexion Google: ${e.toString()}');
    }
  }

  // Connexion via backend
  Future<void> loginWithBackend() async {
    final context = Get.context!;
    try {
      final authResponse = await authService.login(
        email.value.trim(),
        password.value,
      );

      // 🔐 Stocker token et ID utilisateur de façon sécurisée
      await SecureStorageService.writeToken(authResponse.token);
      await SecureStorageService.writeUserId(authResponse.user.id);

      CustomToast.showSuccess(context, 'Connexion réussie via l\'API');
      Get.offAllNamed(Routes.HOME);

    } on InactiveAccountException catch (e) {
      CustomToast.showError(context, e.message);
      Get.toNamed(Routes.LOGIN_OTP, arguments: {'userId': e.userId});
    } catch (e) {
      CustomToast.showError(context, 'Erreur de connexion via l\'API: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      final token = await SecureStorageService.readToken();
      if (token != null) {
        await authService.logout(token);
      }
    } catch (_) {}

    await SecureStorageService.clearAll(); // 🔐 Supprime token & userId
    Get.offAllNamed(Routes.LOGIN);
  }

  void toggleGoogleSignInState() {
    isGoogleSignInClicked.value = !isGoogleSignInClicked.value;
  }
}
