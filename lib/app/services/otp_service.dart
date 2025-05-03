import 'package:get/get.dart';
import 'package:salvage_app/app/config/config.dart';
import 'package:salvage_app/app/services/api_service.dart';

class OtpService extends GetxService {
  final ApiService apiService = ApiService();

  // Envoyer un nouveau code OTP
  Future<void> resendOtp(String userId) async {
    final endpoint = '/users/$userId/send-otp';

    final response = await apiService.postRequest(endpoint, {});
    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Erreur lors de l\'envoi du code');
    }
  }

  // Vérifier le code OTP entré
  Future<void> verifyOtp(String userId, String code) async {
    final endpoint = '/users/verify-otp';
    final body = {
      'userId': userId,
      'code': code,
    };

    final response = await apiService.postRequest(endpoint, body);
    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Code invalide');
    }
  }
}
