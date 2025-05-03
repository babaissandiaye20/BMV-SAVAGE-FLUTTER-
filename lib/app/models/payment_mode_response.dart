class PaymentMode {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? deletedAt;

  PaymentMode({
    required this.id,
    required this.name,
    required this.createdAt,
    this.deletedAt,
  });

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
