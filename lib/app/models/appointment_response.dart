enum AppointmentStatus {
  PENDING,
  CONFIRMED,
  CANCELED,
}

class Appointment {
  final String id;
  final String userId;
  final DateTime scheduledAt;
  final String location;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Appointment({
    required this.id,
    required this.userId,
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
      scheduledAt: DateTime.parse(json['scheduledAt']),
      location: json['location'],
      status: AppointmentStatus.values.firstWhere((e) => e.toString() == 'AppointmentStatus.${json['status']}'),
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
