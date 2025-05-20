import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/payment/controllers/payment_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import '../../../models/payment_mode_response.dart';

class ConfirmPaymentView extends StatelessWidget {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.text),
        title: const Text("Payment Method", style: TextStyle(color: AppColors.text)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("assets/images/logo-payement.png", height: 100),
            const SizedBox(height: 16),
            Obx(() => Text(
              "Total: \$${controller.totalAmount.value.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 8),
            const Text("Choose your preferred method", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 24),

            Obx(() => DropdownButtonFormField<PaymentMode>(
              decoration: const InputDecoration(
                labelText: "Payment Method",
                border: OutlineInputBorder(),
              ),
              value: controller.selectedPaymentMode.value,
              items: controller.paymentModes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name),
                );
              }).toList(),
              onChanged: (mode) {
                controller.selectedPaymentMode.value = mode;
              },
            )),

            const SizedBox(height: 24),
            CustomButton(
              text: "Pay with ${controller.selectedPaymentMode.value?.name ?? '...'}",
              backgroundColor: Colors.red,
              onTap: () => controller.initiateStripePayment(),
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
