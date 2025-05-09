import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/routes/app_pages.dart';

class LandingView extends StatefulWidget {
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(Routes.LOGIN); // Redirection vers la page de login
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/landing.png',
          width: 200,
        ),
      ),
    );
  }
}
