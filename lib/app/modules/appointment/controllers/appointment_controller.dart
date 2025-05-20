
import 'package:get/get.dart';

import '../../../models/appointment_response.dart';


class AppointmentController extends GetxController {
  final appointments = <AppointmentRequest>[].obs;

  @override
  void onInit() {
    // Simule des rendez-vous
    appointments.addAll([
      AppointmentRequest(
        id:"1",
        userId: "1",
        vin: "ABC123",
        vehicleType: "Car",
        titleNumber: "123456",
        scheduledAt: "2025-05-27T10:00:00",
        location: "Columbus BMV",
      ),
      AppointmentRequest(
        id:"2",
        userId: "2",
        vin: "DEF456",
        vehicleType: "Truck",
        titleNumber: "654321",
        scheduledAt: null,
        location: "Cleveland BMV",
      ),
      AppointmentRequest(
        id:"3",
        userId: "3",
        vin: "GHI789",
        vehicleType: "Bike",
        titleNumber: "789123",
      ),
    ]);
    super.onInit();
  }
}

