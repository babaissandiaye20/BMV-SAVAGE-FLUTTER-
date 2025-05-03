enum PaymentStatus {
  INITIATED,
  PAID,
  FAILED,
}

class Payment {
  final String id;
  final String userId;
  final String appointmentId;
  final String paymentModeId;
  final PaymentStatus status;
  final String transactionId;
  final double amount;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Payment({
    required this.id,
    required this.userId,
    required this.appointmentId,
    required this.paymentModeId,
    required this.status,
    required this.transactionId,
    required this.amount,
    required this.createdAt,
    this.deletedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['userId'],
      appointmentId: json['appointmentId'],
      paymentModeId: json['paymentModeId'],
      status: PaymentStatus.values.firstWhere((e) => e.toString() == 'PaymentStatus.${json['status']}'),
      transactionId: json['transactionId'],
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
