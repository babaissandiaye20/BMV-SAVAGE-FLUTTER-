import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class OcrService {
  static final Map<String, String> _prompts = {
    'license': '''
Voici un permis de conduire.
Extrait les champs suivants :
- nom
- prénom
- date de naissance
- numéro du permis
- catégorie.

Réponds uniquement en JSON. Utilise les clés : nom, prénom, license_number.
''',
    'title': '''
Voici une carte grise (titre de véhicule).
Extrait les champs suivants :
- VIN
- type de véhicule
- numéro de titre
- lieu

Réponds uniquement en JSON.
''',
    'combined': '''
Voici un document combiné (carte grise + permis).
Extrait les champs suivants :
- VIN
- type de véhicule
- numéro de titre
- lieu

Réponds uniquement en JSON.
''',
    'receipt': '''
Voici un reçu d'inspection de véhicule.
Extrait :
- Receipt No
- Issue Date

Réponds uniquement en JSON.
''',
  };

  Future<Map<String, dynamic>> processImage(String imagePath, {required String scanType}) async {
    if (!_prompts.containsKey(scanType)) {
      throw Exception('Type de scan non supporté : $scanType');
    }

    final base64Image = await compute(_encodeImageToBase64, imagePath);
    final prompt = _prompts[scanType]!;

    final body = jsonEncode({
      "model": "google/gemini-2.0-flash-001",
      "messages": [
        {
          "role": "user",
          "content": [
            { "type": "text", "text": prompt },
            {
              "type": "image_url",
              "image_url": {
                "url": "data:image/jpeg;base64,$base64Image"
              }
            }
          ]
        }
      ]
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Config.openRouterApiKey}',
      'HTTP-Referer': 'https://votre-app.com',
      'X-Title': 'Salvage App',
    };

    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final response = await http.post(url, headers: headers, body: body);

    print('🔍 Réponse OCR brute : ${response.body}');

    if (response.statusCode != 200) {
      throw Exception("Erreur API OpenRouter (${response.statusCode}) : ${response.body}");
    }

    final decoded = jsonDecode(response.body);

    if (decoded == null ||
        decoded['choices'] == null ||
        !(decoded['choices'] is List) ||
        decoded['choices'].isEmpty ||
        decoded['choices'][0]['message'] == null ||
        decoded['choices'][0]['message']['content'] == null) {
      throw Exception("Réponse inattendue de l'API OCR : ${jsonEncode(decoded)}");
    }

    final contentStr = decoded['choices'][0]['message']['content'] as String;

    final cleaned = contentStr
        .replaceAll(RegExp(r'```json', caseSensitive: false), '')
        .replaceAll(RegExp(r'```'), '')
        .trim();

    final jsonResult = await compute(_parseAndNormalizeJson, cleaned);
    return jsonResult;
  }

  // -- Isolate helpers --

  static String _encodeImageToBase64(String path) {
    final file = File(path);
    final bytes = file.readAsBytesSync(); // OK ici, hors du main thread
    return base64Encode(bytes);
  }

  static Map<String, dynamic> _parseAndNormalizeJson(String cleanedContent) {
    try {
      final parsed = jsonDecode(cleanedContent);
      if (parsed is Map<String, dynamic>) {
        return _normalizeKeys(parsed);
      } else {
        throw const FormatException("Le contenu JSON n'est pas un objet valide.");
      }
    } catch (e) {
      throw Exception("Erreur JSON OCR : ${e.toString()}");
    }
  }

  static Map<String, dynamic> _normalizeKeys(Map<String, dynamic> original) {
    final corrected = <String, dynamic>{};

    original.forEach((key, value) {
      final fixedKey = key
          .replaceAll('Ã©', 'é')
          .replaceAll('Ã¨', 'è')
          .replaceAll('Ãª', 'ê')
          .replaceAll('Ã ', 'à')
          .replaceAll('Ã¢', 'â')
          .replaceAll('Ã§', 'ç')
          .replaceAll('Ã´', 'ô')
          .replaceAll('Ã»', 'û')
          .replaceAll('Ã€', 'À')
          .replaceAll('Ã‰', 'É')
          .replaceAll('Ã', 'à'); // pour attraper les cas bruts
      corrected[fixedKey] = value;
    });

    return corrected;
  }
}
