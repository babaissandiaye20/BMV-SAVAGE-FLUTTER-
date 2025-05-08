import 'package:flutter/material.dart';
import 'package:salvage_app/app/theme/app_theme.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
