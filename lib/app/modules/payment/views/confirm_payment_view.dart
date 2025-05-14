import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_button.dart';

class ConfirmPaymentView extends StatelessWidget {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.text),
        title: const Text("Payment Method", style: TextStyle(color: AppColors.text)),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Ajout de SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("assets/images/logo-payement.png", height: 100),
            const SizedBox(height: 16),
            const Text("Total: \$150.00", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Choose your preferred method", style: TextStyle(fontSize: 14)),

            const SizedBox(height: 24),

            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(
                labelText: "Card Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    decoration: const InputDecoration(
                      labelText: "MM/YY",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(
                      labelText: "CVV",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Cardholder Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: "Pay with Stripe",
              backgroundColor: Colors.red,
              onTap: () {
                Get.snackbar("Succès", "Paiement effectué !");
                Get.back();
              },
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}