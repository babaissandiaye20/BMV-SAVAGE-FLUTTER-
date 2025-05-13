import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class PaymentCard extends StatelessWidget {
  final String vehicleTitle;
  final List<String> items;
  final String fee;

  const PaymentCard({
    super.key,
    required this.vehicleTitle,
    required this.items,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicleTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // 👈 plus grand
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
                (item) => Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16, // 👈 plus grand
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Fee: $fee",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
