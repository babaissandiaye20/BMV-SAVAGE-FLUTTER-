import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';


class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text("Merci pour votre paiement.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              const Text("Votre demande a bien été reçue."),
              const SizedBox(height: 12),
              const Text(
                  "Vous recevrez une notification pour la date de rendez-vous dans les prochaines heures ou jours, selon nos disponibilités."),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                },
                child: const Text("Retour à l’accueil"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
