import 'package:salvage_app/app/services/api_service.dart';

import '../models/appointment_response.dart';


class AppointmentService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createAppointment({
    required AppointmentRequest request,
    required String token,
  }) async {
    try {
      final response = await _apiService.postRequest(
        '/appointment',
        request.toJson(),
        token: token,
      );

      print("🔴 Réponse brute de l'API : $response"); // 👈 Log complet ici

      return response;
    } catch (e) {
      print("🔴 Exception API : $e"); // 👈 utile si _apiService lance une erreur
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPendingAppointmentsWithoutPayment({
    required String userId,
    required String token,
  }) async {
    return await _apiService.getRequest(
      '/appointment/user/$userId/pending/no-payment',
      token: token,
    );
  }

}
