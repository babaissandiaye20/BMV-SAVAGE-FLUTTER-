class PaymentRequestResponse {
  final String userId;
  final List<String> appointmentIds;
  final String paymentModeId;
  final List<double> amounts;
  final String currency;
  final String? checkoutUrl;

  PaymentRequestResponse({
    required this.userId,
    required this.appointmentIds,
    required this.paymentModeId,
    required this.amounts,
    required this.currency,
    this.checkoutUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'appointmentIds': appointmentIds,
      'paymentModeId': paymentModeId,
      'amounts': amounts,
      'currency': currency,
    };
  }

  factory PaymentRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaymentRequestResponse(
      userId: json['userId'] ?? '',
      appointmentIds: List<String>.from(json['appointmentIds'] ?? []),
      paymentModeId: json['paymentModeId'] ?? '',
      amounts: List<double>.from(
        (json['amounts'] ?? []).map((e) => e.toDouble()),
      ),
      currency: json['currency'] ?? '',
      checkoutUrl: json['checkoutUrl'],
    );
  }
}
