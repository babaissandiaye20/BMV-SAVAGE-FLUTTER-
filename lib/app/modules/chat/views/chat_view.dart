import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('💬 Chat Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.offAllNamed('/home'),
          tooltip: 'Retour à l’accueil 🏠',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => Get.snackbar("📞 Support", "Calling support... (soon 😉)",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.black,
                colorText: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
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
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg.audio
                              ? Colors.grey[300]
                              : msg.fromUser
                              ? Colors.black
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: msg.audio
                            ? const Icon(Icons.mic, color: Colors.black54)
                            : Text(
                          msg.text ?? '',
                          style: TextStyle(
                            color: msg.fromUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        msg.time,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    );
  }

  Widget _buildInputBar(TextEditingController controllerText) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
        ),
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
                  fillColor: Colors.grey[200],
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
