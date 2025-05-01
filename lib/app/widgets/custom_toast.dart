import 'package:flutter/material.dart';

class CustomToast {
  static late BuildContext _rootContext;

  static void setContext(BuildContext context) {
    _rootContext = context;
  }

  static void showSuccess(BuildContext context, String message) {
    _showToast(message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showToast(message, Colors.red);
  }

  static void _showToast(String message, Color color) {
    final overlay = Overlay.of(_rootContext);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 24,
        right: 24,
        child: _buildToast(message, color),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  static Widget _buildToast(String message, Color color) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
