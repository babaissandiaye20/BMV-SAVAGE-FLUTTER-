import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/config/config.dart';

void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  try {
    Stripe.publishableKey = Config.getStripePublishableKey();
    await Stripe.instance.applySettings();
    print('Stripe initialized successfully');
  } catch (e) {
    print('Stripe initialization failed: $e');
  }

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      title: 'Salvage App',
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
