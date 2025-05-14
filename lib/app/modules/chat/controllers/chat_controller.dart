import 'package:get/get.dart';

class ChatMessage {
  final bool fromUser;
  final String? text;
  final bool audio;
  final String time;

  ChatMessage({
    required this.fromUser,
    this.text,
    this.audio = false,
    required this.time,
  });
}

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[
    ChatMessage(fromUser: false, text: 'Hello, I have an issue with my documents.', time: '09h30'),
    ChatMessage(fromUser: true, text: 'Hi! Could you please describe the issue you’re facing?', time: '09h30'),
    ChatMessage(fromUser: false, audio: true, time: '09h31'),
  ].obs;

  void sendText(String text) {
    final now = DateTime.now();
    final time = "${now.hour.toString().padLeft(2, '0')}h${now.minute.toString().padLeft(2, '0')}";
    messages.add(ChatMessage(fromUser: true, text: text, time: time));
  }

  void sendAudio() {
    final now = DateTime.now();
    final time = "${now.hour.toString().padLeft(2, '0')}h${now.minute.toString().padLeft(2, '0')}";
    messages.add(ChatMessage(fromUser: true, audio: true, time: time));
  }
}
