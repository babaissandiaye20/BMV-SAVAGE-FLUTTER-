class AppointmentRequest {
  final String userId;
  final String vin;
  final String vehicleType;
  final String titleNumber;
  final String? receiptNumber;
  final String? issuesDate;
  final String? scheduledAt;
  final String? location;

  AppointmentRequest({
    required this.userId,
    required this.vin,
    required this.vehicleType,
    required this.titleNumber,
    this.receiptNumber,
    this.issuesDate,
    this.scheduledAt,
    this.location,
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
}
