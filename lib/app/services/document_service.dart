import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart'; // à bien importer
import 'package:salvage_app/app/services/api_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';

import '../models/document_response.dart';

class DocumentService {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> uploadDocument(File file, String type) async {
    final token = await SecureStorageService.readToken();
    if (token == null) throw Exception("Token manquant");

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final parts = mimeType.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(parts[0], parts[1]),
      filename: path.basename(file.path),
    );

    return await apiService.postMultipartRequest(
      endpoint: '/documents/upload',
      fields: {'type': type.toUpperCase()},
      files: [multipartFile],
      token: token,
    );
  }

  Future<List<Document>> getDocuments() async {
    final token = await SecureStorageService.readToken();
    print(token);
    if (token == null) throw Exception("Token manquant");

    final response = await apiService.getRequest('/documents', token: token);
    final List data = response['data'] ?? [];
    return data.map((e) => Document.fromJson(e)).toList();
  }
}
