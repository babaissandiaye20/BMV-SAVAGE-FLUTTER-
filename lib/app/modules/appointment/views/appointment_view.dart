
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/appointment_response.dart';
import '../../../theme/app_theme.dart';
import '../controllers/appointment_controller.dart';


class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "confirmed":
        return Colors.green;
      case "pending":
        return AppColors.primary;
      default:
        return AppColors.inputHint;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case "confirmed":
        return "Confirmed";
      case "pending":
        return "Pending";
      default:
        return "";
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "confirmed":
        return Icons.check_circle_outline;
      case "pending":
        return Icons.access_time;
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        title: const Text("Appointment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => ListView.builder(
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appt = controller.appointments[index];
            final status = _getStatus(appt);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor.withOpacity(0.2)),
                color: status == "none"
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_statusIcon(status), size: 28, color: _statusColor(status)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt.location ?? "Unknown",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          status == "confirmed"
                              ? _formatScheduledDate(appt.scheduledAt!)
                              : status == "pending"
                              ? "Waiting for confirmation"
                              : "You’ll be notified once your request is validated.",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (status != "none")
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Text(
                        _statusText(status),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        )),
      ),
    );
  }

  String _getStatus(AppointmentRequest appt) {
    if (appt.scheduledAt != null && appt.scheduledAt!.isNotEmpty) return "confirmed";
    if (appt.location != null && appt.location!.isNotEmpty) return "pending";
    return "none";
  }

  String _formatScheduledDate(String scheduledAt) {
    final date = DateTime.tryParse(scheduledAt);
    if (date == null) return scheduledAt;

    final weekday = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ][date.weekday - 1];

    final month = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][date.month - 1];

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return "$weekday, $month ${date.day}, ${date.year} at $hour:$minute";
  }
}

