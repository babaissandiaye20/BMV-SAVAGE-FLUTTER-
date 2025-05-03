import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../config/http_response_config.dart';

class ApiService extends GetxService {
  // Méthode pour envoyer une requête POST
  Future<Map<String, dynamic>> postRequest(
      String endpoint,
      dynamic body, {
        String? token,
      }) async {
    try {
      print("Données envoyées : $body");

      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
        body: json.encode(body),
      );

      print("Réponse API : ${response.body}");

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Méthode pour gérer la réponse en utilisant la configuration
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final responseBody = json.decode(response.body);

      if (responseBody is Map<String, dynamic>) {
        // Récupérer la config par défaut selon le status code
        final config = HttpResponseConfig.getResponseConfig(response.statusCode);

        return {
          'statusCode': response.statusCode,
          'status': responseBody['status'] ?? config['status'],
          'message': responseBody['message'] ?? config['message'],
          'data': responseBody['data'],
          'errors': responseBody['errors'],
          'meta': config, // Pour usage futur/debug
        };
      } else {
        throw Exception('Réponse de l\'API mal formatée');
      }
    } catch (e) {
      throw Exception('Erreur lors du traitement de la réponse: $e');
    }
  }
}
