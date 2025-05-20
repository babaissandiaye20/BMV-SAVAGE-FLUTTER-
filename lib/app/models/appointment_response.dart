class AppointmentRequest {
  final String id;
  final String userId;
  final String vin;
  final String vehicleType;
  final String titleNumber;
  final String? receiptNumber;
  final String? issuesDate;
  final String? scheduledAt;
  final String? location;

  double? price;

  AppointmentRequest({
    required this.id,
    required this.userId,
    required this.vin,
    required this.vehicleType,
    required this.titleNumber,
    this.receiptNumber,
    this.issuesDate,
    this.scheduledAt,
    this.location,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) "id": id,
      "userId": userId,
      "vin": vin,
      "vehicleType": vehicleType,
      "titleNumber": titleNumber,
      if (receiptNumber?.isNotEmpty ?? false) "receiptNumber": receiptNumber,
      if (issuesDate?.isNotEmpty ?? false) "issuesDate": issuesDate,
      if (scheduledAt?.isNotEmpty ?? false) "scheduledAt": scheduledAt,
      if (location?.isNotEmpty ?? false) "location": location,
    };
  }

  factory AppointmentRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentRequest(
      id: json['id'] ?? '',
      userId: json['userId'],
      vin: json['vin'],
      vehicleType: json['vehicleType'],
      titleNumber: json['titleNumber'],
      receiptNumber: json['receiptNumber'],
      issuesDate: json['issuesDate'],
      scheduledAt: json['scheduledAt'],
      location: json['location'],
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
    );
  }

  /// Factory sans ID — pour création côté client sans valeur `id`
  factory AppointmentRequest.fromPartialJson(Map<String, dynamic> json) {
    return AppointmentRequest(
      id: '', // ID vide, généré ou géré par backend
      userId: json['userId'],
      vin: json['vin'],
      vehicleType: json['vehicleType'],
      titleNumber: json['titleNumber'],
      receiptNumber: json['receiptNumber'],
      issuesDate: json['issuesDate'],
      scheduledAt: json['scheduledAt'],
      location: json['location'],
    );
  }

  void setPrice(double value) {
    price = value;
  }
}
