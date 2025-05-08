import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/http_response_config.dart';

class ApiService extends GetxService {
  // JSON POST
  Future<Map<String, dynamic>> postRequest(
      String endpoint,
      dynamic body, {
        String? token,
      }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Multipart POST
  Future<Map<String, dynamic>> postMultipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('${Config.getApiUrl()}$endpoint');

      final request = http.MultipartRequest('POST', uri)
        ..fields.addAll(fields)
        ..files.addAll(files);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur multipart: $e');
    }
  }

  // GET
  Future<Map<String, dynamic>> getRequest(String endpoint, {String? token}) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur GET: $e');
    }
  }

  // Handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final responseBody = json.decode(response.body);

      if (responseBody is Map<String, dynamic>) {
        final config = HttpResponseConfig.getResponseConfig(response.statusCode);
        return {
          'statusCode': response.statusCode,
          'status': responseBody['status'] ?? config['status'],
          'message': responseBody['message'] ?? config['message'],
          'data': responseBody['data'],
          'errors': responseBody['errors'],
          'meta': config,
        };
      } else {
        throw Exception('Réponse de l\'API mal formatée');
      }
    } catch (e) {
      throw Exception('Erreur réponse: $e');
    }
  }
}
