import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:salvage_app/app/modules/payment/controllers/payment_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Paiement',
          style: TextStyle(color: AppColors.text),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.paymentModes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Montant à payer : \$${controller.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Mode de paiement",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: controller.selectedModeId.value.isNotEmpty
                      ? controller.selectedModeId.value
                      : null,
                  isExpanded: true,
                  items: controller.paymentModes.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode['id'],
                      child: Text(mode['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedModeId.value = value;
                    }
                  },
                ),

                const SizedBox(height: 24),
                const Text(
                  "Carte bancaire",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                CardField(
                  onCardChanged: (card) {
                    controller.cardDetails = card;
                  },
                ),

                const Spacer(),

                Obx(() => CustomButton(
                  text: controller.isLoading.value
                      ? "Paiement en cours..."
                      : "Payer maintenant",
                  onTap: () {
                    if (!controller.isLoading.value) {
                      controller.pay();
                    }
                  },
                )),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ),
    );
  }
}
