enum AppointmentStatus {
  PENDING,
  CONFIRMED,
  CANCELED,
}

class Appointment {
  final String id;
  final String userId;
  final String vin;
  final String vehicleType;
  final String titleNumber;
  final String scheduledAt; // REST backend attend une string ISO
  final String location;
  final AppointmentStatus status;
  final DateTime createdAt;
  final String? deletedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.vin,
    required this.vehicleType,
    required this.titleNumber,
    required this.scheduledAt,
    required this.location,
    required this.status,
    required this.createdAt,
    this.deletedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      vin: json['vin'],
      vehicleType: json['vehicleType'],
      titleNumber: json['titleNumber'],
      scheduledAt: json['scheduledAt'],
      location: json['location'],
      status: AppointmentStatus.values.firstWhere(
            (e) => e.toString() == 'AppointmentStatus.${json['status']}',
        orElse: () => AppointmentStatus.PENDING,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'],
    );
  }
}
