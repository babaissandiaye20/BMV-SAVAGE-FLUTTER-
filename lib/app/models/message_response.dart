class Message {
  final String id;
  final String userId;
  final String content;
  final bool isAdmin;
  final DateTime sentAt;
  final DateTime? deletedAt;

  Message({
    required this.id,
    required this.userId,
    required this.content,
    required this.isAdmin,
    required this.sentAt,
    this.deletedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      isAdmin: json['isAdmin'],
      sentAt: DateTime.parse(json['sentAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
