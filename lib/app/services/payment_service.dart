
import 'package:salvage_app/app/services/api_service.dart';

import '../models/payment_response.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<PaymentRequestResponse> createCheckoutSession({
    required String token,
    required PaymentRequestResponse request,
  }) async {
    final response = await _apiService.postRequest(
      '/payments',
      token: token,
       request.toJson(),
    );

    return PaymentRequestResponse.fromJson(response['data']);
  }
}
