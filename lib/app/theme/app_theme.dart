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
  static const Color googleBorder = Color(0xFFDDDDDD);
  static const Color chatBackground = Color(0xFF00A884);   // Teal background (adjusted to match screenshot)
  static const Color userMessageBubble = Color(0xFF25D366); // WhatsApp green for user messages
  static const Color otherMessageBubble = Color(0xFFFFFFFF); // White for other messages
  static const Color timestampText = Color(0xFF666666);     // Gray for timestamps
  static const Color inputBarBackground = Color(0xFFF0F0F0); // Light gray for inpu
}



  // Bordure bouton Google

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
