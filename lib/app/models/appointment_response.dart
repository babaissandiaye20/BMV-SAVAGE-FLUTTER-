class AppointmentRequest {
  final String userId;
  final String vin;
  final String vehicleType;
  final String titleNumber;
  final String? receiptNumber;
  final String? issuesDate;
  final String? scheduledAt;
  final String? location;

  double? price; // 👈 utilisé localement

  AppointmentRequest({
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
      "userId": userId,
      "vin": vin,
      "vehicleType": vehicleType,
      "titleNumber": titleNumber,
      if (receiptNumber != null && receiptNumber!.isNotEmpty) "receiptNumber": receiptNumber,
      if (issuesDate != null && issuesDate!.isNotEmpty) "issuesDate": issuesDate,
      if (scheduledAt != null && scheduledAt!.isNotEmpty) "scheduledAt": scheduledAt,
      if (location != null && location!.isNotEmpty) "location": location,
    };
  }

  factory AppointmentRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentRequest(
      userId: json['userId'],
      vin: json['vin'],
      vehicleType: json['vehicleType'],
      titleNumber: json['titleNumber'],
      receiptNumber: json['receiptNumber'],
      issuesDate: json['issuesDate'],
      scheduledAt: json['scheduledAt'],
      location: json['location'],
      price: json['price']?.toDouble(), // pris en compte localement
    );
  }

  void setPrice(double value) {
    price = value;
  }
}
