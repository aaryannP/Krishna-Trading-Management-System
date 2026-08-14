class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;
  final String? adminSecurityKey;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    this.adminSecurityKey,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'RETAIL_CUSTOMER',
      isActive: json['is_active'] ?? true,
      adminSecurityKey: json['admin_security_key'],
    );
  }
}
