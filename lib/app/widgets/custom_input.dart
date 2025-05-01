import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String> onChanged;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
          if (suffixIcon != null) ...[suffixIcon!, const SizedBox(width: 8)],
        ],
      ),
    );
  }
}
