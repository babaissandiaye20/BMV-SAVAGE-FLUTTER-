/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support - Chat'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isUser = msg.isUser;
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primary : AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.white,
            child: Row(
              children: [
                // Nouveau bouton vocal
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.primary),
                  onPressed: () {
                    // TODO: implémenter enregistrement vocal ou STT
                    Get.snackbar("Info", "Fonction vocale non encore activée.");
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: 'Écrivez votre message...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.inputBorder),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
