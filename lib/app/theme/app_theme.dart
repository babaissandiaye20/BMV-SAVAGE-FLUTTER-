import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF800000);
  static const Color secondary = Color(0xFFFFD700);
  static const Color background = Color(0xFFF5F5F5);
  static const Color text = Color(0xFF000000);
  static const Color inputBorder = Color(0xFFE5E7EB);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: 'Roboto',
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}
