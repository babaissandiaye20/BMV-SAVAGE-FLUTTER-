import 'dart:convert';
import 'package:get/get.dart';
import 'package:salvage_app/app/config/config.dart';
import 'package:salvage_app/app/models/auth_response.dart';
import 'package:salvage_app/app/services/api_service.dart';

/// Exception personnalisée pour un compte inactif
class InactiveAccountException implements Exception {
  final String message;
  final String userId;

  InactiveAccountException(this.message, this.userId);

  @override
  String toString() => message;
}

class AuthService extends GetxService {
  final ApiService apiService = ApiService();

  // Connexion de l'utilisateur
  Future<AuthResponse> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    print("Données envoyées : $body");

    final response = await apiService.postRequest(
      "${Config.authEndpoint}/login",
      body,
    );

    if (response['status'] == 'success') {
      final data = response['data'];
      final user = data['user'];

      if (user is Map<String, dynamic>) {
        final token = data['token'];
        final refreshToken = data['refreshToken'] != null
            ? data['refreshToken']['token']
            : null;

        return AuthResponse.fromJson({
          'token': token,
          'refreshToken': refreshToken,
          'user': user,
        });
      } else {
        throw Exception('Format de données utilisateur invalide');
      }
    } else {
      final statusCode = response['statusCode'];
      final message = response['message'] ?? 'Erreur inconnue';

      print("Message d'erreur du backend: $message");

      // Gestion spécifique du compte inactif
      if (statusCode == 400 && message == 'Compte inactif') {
        final userId = response['data']?['user']?['id'];
        if (userId != null) {
          throw InactiveAccountException(message, userId);
        }
      }

      // Autre erreur générique
      throw Exception(message);
    }
  }

  // Rafraîchir le token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    final body = {
      'refreshToken': refreshToken,
    };

    final response = await apiService.postRequest(
      "${Config.authEndpoint}/refresh",
      body,
    );

    if (response['status'] == 'success') {
      final data = response['data'];

      if (data != null &&
          data.containsKey('user') &&
          data.containsKey('token')) {
        final user = data['user'];

        if (user is Map<String, dynamic>) {
          final token = data['token'];
          final newRefreshToken = data['refreshToken'] != null
              ? data['refreshToken']['token']
              : null;

          return AuthResponse.fromJson({
            'token': token,
            'refreshToken': newRefreshToken,
            'user': user,
          });
        } else {
          throw Exception('Format de données utilisateur invalide');
        }
      } else {
        throw Exception('Données utilisateur ou token manquantes');
      }
    } else {
      final message = response['message'] ?? 'Erreur inconnue';
      throw Exception(message);
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> logout(String token) async {
    final response = await apiService.postRequest(
      "${Config.authEndpoint}/logout",
      {},
      token: token,
    );

    if (response['status'] != 'success') {
      throw Exception('Erreur lors de la déconnexion');
    }
  }
}
