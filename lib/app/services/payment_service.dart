import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salvage_app/app/services/secure_storage_service.dart';
import '../config/config.dart';

class PaymentService {
  static Future<Map<String, dynamic>> createPayment({
    required String userId,
    required String appointmentId,
    required String paymentModeId,
    required double amount,
    required String currency,
    required String paymentMethodId,
  }) async {
    final token = await SecureStorageService.readToken();

    final response = await http.post(
      Uri.parse('${Config.getApiUrl()}/payments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'appointmentId': appointmentId,
        'paymentModeId': paymentModeId,
        'amount': amount,
        'currency': currency,
        'paymentDetails': {
          'paymentMethodId': paymentMethodId,
        },
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erreur lors du paiement');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPaymentModes() async {
    final token = await SecureStorageService.readToken();

    final response = await http.get(
      Uri.parse('${Config.getApiUrl()}/payment-modes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['data']);
  }
}

