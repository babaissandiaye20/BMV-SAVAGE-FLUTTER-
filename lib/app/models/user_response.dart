class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isPhoneVerified;
  final String? codeOtp;
  final String phone;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isPhoneVerified,
    this.codeOtp,
    required this.phone,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isPhoneVerified: json['isPhoneVerified'],
      codeOtp: json['codeOtp'],
      phone: json['phone'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
