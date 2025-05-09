import 'package:salvage_app/app/services/api_service.dart';

import '../models/appointment_response.dart';


class AppointmentService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createAppointment({
    required AppointmentRequest request,
    required String token,
  }) async {
    return await _apiService.postRequest(
      '/appointment',
      request.toJson(),
      token: token,
    );
  }
}
