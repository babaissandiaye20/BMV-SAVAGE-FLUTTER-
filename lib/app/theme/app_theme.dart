import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFDA1E1E); // Rouge vif pour bouton "Sign in"
  static const Color secondary = Color(0xFF000000); // Fond noir
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFF000000); // Champs input noirs
  static const Color inputText = Color(0xFFFFFFFF);       // Texte blanc
  static const Color inputHint = Color(0xFFB0B0B0);        // Hint grisé
  static const Color borderColor = Color(0xFF000000);      // Bordure noire
  static const Color text = Color(0xFF000000);
  static const Color googleBorder = Color(0xFFDDDDDD);     // Bordure bouton Google
}

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    fontFamily: 'Roboto',
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
