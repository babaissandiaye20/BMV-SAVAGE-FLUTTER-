import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/chat_controller.dart';
 // Import your AppTheme

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: AppColors.chatBackground, // Teal background
        appBar: AppBar(
          title: const Text('Support'),
          centerTitle: false,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.text,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.offAllNamed('/home'),
            tooltip: 'Retour à l’accueil 🏠',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => Get.snackbar(
                "📞 Support",
                "Calling support... (soon 😉)",
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppColors.secondary,
                colorText: AppColors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Display "Messages and calls are end-to-end encrypted" banner
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 14,
                    color: AppColors.timestampText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Messages and calls are end-to-end encrypted',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.timestampText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return Align(
                    alignment: msg.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: msg.fromUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75, // Limit bubble width
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: msg.audio
                                ? AppColors.otherMessageBubble // White for audio
                                : msg.fromUser
                                ? AppColors.userMessageBubble // Green for user
                                : AppColors.otherMessageBubble, // White for others
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: msg.audio
                              ? const Icon(Icons.mic, color: AppColors.text)
                              : Text(
                            msg.text ?? '',
                            style: TextStyle(
                              color: msg.fromUser ? AppColors.white : AppColors.text,
                            ),
                          ),
                        ),
                        Text(
                          msg.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.timestampText,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              )),
            ),
            _buildInputBar(textController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(TextEditingController controllerText) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: AppColors.inputBarBackground, // Light gray input bar
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllerText,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: AppColors.white, // White text field
                  filled: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final text = controllerText.text.trim();
                if (text.isNotEmpty) {
                  controller.sendText(text);
                  controllerText.clear();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                controller.sendAudio();
              },
            ),
          ],
        ),
      ),
    );
  }
}