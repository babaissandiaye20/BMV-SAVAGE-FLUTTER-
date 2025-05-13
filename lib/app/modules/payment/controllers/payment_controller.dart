import 'package:get/get.dart';
import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/services/secure_storage_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import '../../../models/appointment_response.dart';

class PaymentController extends GetxController {
  final AppointmentService _appointmentService = AppointmentService();

  var appointments = <AppointmentRequest>[].obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;

    try {
      final token = await SecureStorageService.readToken();
      final userId = await SecureStorageService.readUserId();

      if (token == null || userId == null) {
        CustomToast.showError(Get.context!, "Utilisateur non authentifié.");
        return;
      }

      final data = await _appointmentService.getPendingAppointmentsWithoutPayment(
        userId: userId,
        token: token,
      );

      // ✅ Récupère la vraie liste depuis la clé 'data'
      final results = data['data'] as List<dynamic>;

      appointments.assignAll(results.map((e) {
        final appt = AppointmentRequest.fromJson(e);
        final hasReceipt = appt.receiptNumber != null && appt.receiptNumber!.isNotEmpty;
        final base = 30.0;
        final extra = hasReceipt ? 0.0 : 10.0;
        appt.setPrice(base + extra);
        return appt;
      }).toList());

      calculateTotal();

    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur de chargement des rendez-vous: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void calculateTotal() {
    double sum = 0;
    for (var appointment in appointments) {
      sum += appointment.price ?? 0;
    }
    totalAmount.value = sum;
  }
}
