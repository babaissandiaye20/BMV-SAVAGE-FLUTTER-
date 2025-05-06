import 'package:salvage_app/app/services/api_service.dart';

class AppointmentService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createAppointment({
    required String userId,
    required String vin,
    required String vehicleType,
    required String titleNumber,
    required String scheduledAt,
    required String location,
  }) async {
    final body = {
      "userId": userId,
      "vin": vin,
      "vehicleType": vehicleType,
      "titleNumber": titleNumber,
      "scheduledAt": scheduledAt,
      "location": location,
    };

    return await _apiService.postRequest('/appointment', body);
  }
}
