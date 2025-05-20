// services/payment_mode_service.dart

import 'package:salvage_app/app/services/api_service.dart';

import '../models/payment_mode_response.dart';

class PaymentModeService {
  final ApiService _apiService = ApiService();

  Future<List<PaymentMode>> getAllPaymentModes({required String token}) async {
    final res = await _apiService.getRequest('/payment-modes', token: token);
    final list = res['data'] as List<dynamic>;
    return list.map((e) => PaymentMode.fromJson(e)).toList();
  }
}
