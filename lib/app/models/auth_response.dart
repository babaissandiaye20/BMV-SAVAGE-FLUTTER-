import 'user_response.dart'; // Importer la classe User ici

class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }
}
