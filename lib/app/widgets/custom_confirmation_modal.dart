import 'package:flutter/material.dart';

class CustomConfirmationModal extends StatelessWidget {
  final String title;
  final String description;
  final String? imageAssetPath; // Pour l'icône de déconnexion
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final List<String>? radioOptions;
  final String? selectedOption;
  final Function(String?)? onRadioChanged;
  final TextEditingController? inputController;

  const CustomConfirmationModal({
    Key? key,
    required this.title,
    required this.description,
    required this.onConfirm,
    required this.onCancel,
    this.imageAssetPath,
    this.confirmText = 'Continue',
    this.cancelText = 'Cancel',
    this.radioOptions,
    this.selectedOption,
    this.onRadioChanged,
    this.inputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAssetPath != null) ...[
              Image.asset(imageAssetPath!, height: 64),
              const SizedBox(height: 20),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (inputController != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: inputController,
                  decoration: const InputDecoration(
                    hintText: "Enter your input",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            if (radioOptions != null && onRadioChanged != null)
              Column(
                children: radioOptions!
                    .map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: onRadioChanged,
                ))
                    .toList(),
              ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.chat, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    label: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}