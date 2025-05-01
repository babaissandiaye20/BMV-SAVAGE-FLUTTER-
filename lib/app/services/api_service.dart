import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../config/http_response_config.dart';
 // Importez la configuration des réponses HTTP

class ApiService extends GetxService {
  // Méthode pour envoyer une requête GET
  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("${Config.getApiUrl()}$endpoint"));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Méthode pour envoyer une requête POST
  Future<Map<String, dynamic>> postRequest(String endpoint, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Méthode pour envoyer une requête PUT
  Future<Map<String, dynamic>> putRequest(String endpoint, dynamic body) async {
    try {
      final response = await http.put(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Méthode pour gérer la réponse en utilisant la configuration
  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = json.decode(response.body);
    final config = HttpResponseConfig.getResponseConfig(response.statusCode);

    // Fusionner les données de la réponse avec les informations de configuration
    return {
      ...config,
      'data': responseBody['data'],
      'errors': responseBody['errors'],
    };
  }

  // Méthode pour uploader un fichier
  Future<Map<String, dynamic>> uploadFile(String endpoint, var file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("${Config.getApiUrl()}$endpoint"));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return {
          'status': 'success',
          'message': 'Fichier téléchargé avec succès',
          'data': json.decode(responseBody),
        };
      } else {
        throw Exception('Échec du téléchargement');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
