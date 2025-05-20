import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/payment/controllers/payment_controller.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';
import 'package:salvage_app/app/widgets/payment_card.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_toast.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.text),
        title: const Text('Payment', style: TextStyle(color: AppColors.text)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.appointments.isEmpty) {
          return const Center(
            child: Text(
              "Aucun rendez-vous à afficher.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.appointments.length,
                  itemBuilder: (context, index) {
                    final appt = controller.appointments[index];
                    final hasReceipt = appt.receiptNumber != null && appt.receiptNumber!.isNotEmpty;
                    final price = appt.price ?? 0;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PaymentCard(
                            vehicleTitle: "Vehicle ${index + 1}",
                            items: [
                              "Car Title",
                              hasReceipt ? "Receipt" : "No receipt provided.",
                            ],
                            fee: "\$${price.toStringAsFixed(2)}",
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deleteAppointment(appt.id),
                        ),
                      ],
                    );


                  },
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => Text(
                "Total: \$${controller.totalAmount.value.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              )),
              const SizedBox(height: 24),
              CustomButton(
                text: "Pay Now",
                onTap: () {
                  if (controller.appointments.length > 20) {
                    CustomToast.showError(context, "Vous ne pouvez pas avoir plus de 20 rendez-vous non payés. Veuillez en supprimer.");
                    return;
                  }
                  Get.toNamed(Routes.CONFIRM_PAYMENT, arguments: controller.totalAmount.value);
                },
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              )



            ],
          ),
        );
      }),
    );
  }
}