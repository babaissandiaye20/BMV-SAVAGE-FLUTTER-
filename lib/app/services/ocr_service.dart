import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../config/config.dart';

class OcrService {
  static final Map<String, String> _prompts = {
    'license': "Voici un permis de conduire. Extrait : nom, prénom, date de naissance, numéro du permis, catégorie. JSON uniquement.",
    'title': "Voici une carte grise. Extrait : VIN, type de véhicule, numéro de titre, lieu. JSON uniquement.",
    'combined': "Voici un document combiné (carte grise + permis). Extrait : VIN, type de véhicule, numéro de titre, lieu. JSON uniquement.",
  };

  Future<Map<String, dynamic>> processImage(String imagePath, {required String scanType}) async {
    final imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    if (!_prompts.containsKey(scanType)) {
      throw Exception('Type de scan non supporté : $scanType');
    }

    final prompt = _prompts[scanType]!;

    final body = jsonEncode({
      "model": "google/gemma-3-4b-it:free",
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": prompt},
            {"type": "image_url", "image_url": {"url": "data:image/jpeg;base64,$base64Image"}}
          ]
        }
      ]
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Config.openRouterApiKey}',
    };

    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception("Erreur API OpenRouter : ${response.body}");
    }

    final decoded = jsonDecode(response.body);
    final content = decoded['choices'][0]['message']['content'] as String;

    // Nettoyage du contenu brut
    final cleaned = content
        .replaceAll(RegExp(r'```json'), '')
        .replaceAll(RegExp(r'```'), '')
        .trim();

    try {
      final jsonResult = jsonDecode(cleaned);
      if (jsonResult is Map<String, dynamic>) {
        return jsonResult;
      } else {
        throw const FormatException('Le contenu n\'est pas un objet JSON valide.');
      }
    } catch (e) {
      throw Exception("Données recherchées non trouvées.");
    }
  }
}
