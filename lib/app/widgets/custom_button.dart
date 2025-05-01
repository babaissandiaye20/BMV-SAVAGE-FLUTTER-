import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final String? imageAsset;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.borderColor,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(32),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null) ...[
              Image.asset(imageAsset!, height: 24),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
