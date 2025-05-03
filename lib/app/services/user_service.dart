import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
    };

    return await _apiService.postRequest("/users", body);
  }
}
