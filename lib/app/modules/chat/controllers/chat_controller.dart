import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage(this.text, this.isUser);
}

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController textController = TextEditingController();

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(text, true));
    textController.clear();

    // Simuler une réponse après 1s
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(ChatMessage("Merci pour votre message. Un agent va vous répondre sous peu.", false));
    });
  }
}
