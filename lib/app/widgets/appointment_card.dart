import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class AppointmentCard extends StatelessWidget {
  final String status;
  final String date;
  final bool? success;

  const AppointmentCard({
    super.key,
    required this.status,
    required this.date,
    this.success,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        success == true
            ? Colors.green
            : success == false
            ? Colors.red
            : AppColors.secondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, size: 32, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
