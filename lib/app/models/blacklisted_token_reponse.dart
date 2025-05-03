class BlacklistedToken {
  final int id;
  final String token;
  final DateTime expiresAt;

  BlacklistedToken({
    required this.id,
    required this.token,
    required this.expiresAt,
  });

  factory BlacklistedToken.fromJson(Map<String, dynamic> json) {
    return BlacklistedToken(
      id: json['id'],
      token: json['token'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
