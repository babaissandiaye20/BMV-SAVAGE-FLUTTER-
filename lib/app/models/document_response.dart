enum DocumentType {
  LICENSE,
  TITLE,
  RECEIPT,
}

class Document {
  final String id;
  final String userId;
  final DocumentType type;
  final String fileUrl;
  final DateTime uploadedAt;
  final DateTime? deletedAt;

  Document({
    required this.id,
    required this.userId,
    required this.type,
    required this.fileUrl,
    required this.uploadedAt,
    this.deletedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      userId: json['userId'],
      type: DocumentType.values.firstWhere((e) => e.toString() == 'DocumentType.${json['type']}'),
      fileUrl: json['fileUrl'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
