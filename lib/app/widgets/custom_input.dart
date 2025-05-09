import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String> onChanged;

  // ✅ Paramètres personnalisables ajoutés :
  final Color fillColor;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final Color iconColor;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.fillColor = AppColors.inputBackground,
    this.textColor = AppColors.inputText,
    this.hintColor = AppColors.inputHint,
    this.borderColor = AppColors.borderColor,
    this.iconColor = AppColors.inputHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              obscureText: obscureText,
              style: TextStyle(color: textColor),
              cursorColor: textColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: hintColor),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon!,
        ],
      ),
    );
  }
}
