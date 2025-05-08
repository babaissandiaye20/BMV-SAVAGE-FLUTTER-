import 'package:flutter/material.dart';

class CustomConfirmationModal extends StatelessWidget {
  final String title;
  final String description;
  final List<String>? radioOptions;
  final String? selectedOption;
  final Function(String?)? onRadioChanged;
  final TextEditingController? inputController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmationModal({
    Key? key,
    required this.title,
    required this.description,
    this.radioOptions,
    this.selectedOption,
    this.onRadioChanged,
    this.inputController,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 16),

              if (inputController != null) ...[
                TextField(
                  controller: inputController,
                  decoration: const InputDecoration(
                    hintText: "Enter your input here",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (radioOptions != null && onRadioChanged != null) ...[
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
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onCancel,
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: onConfirm,
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
