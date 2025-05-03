class RefreshToken {
  final String id;
  final String userId;
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;
  final bool revoked;

  RefreshToken({
    required this.id,
    required this.userId,
    required this.token,
    required this.expiresAt,
    required this.createdAt,
    required this.revoked,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return RefreshToken(
      id: json['id'],
      userId: json['userId'],
      token: json['token'],
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
      revoked: json['revoked'],
    );
  }
}
