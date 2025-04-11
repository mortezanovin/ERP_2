class User {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String roleId;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.isActive,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      roleId: map['role_id'],
      isActive: map['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'role_id': roleId,
      'is_active': isActive,
    };
  }
}
