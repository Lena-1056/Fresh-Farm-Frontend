class AuthResponse {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;

  AuthResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'BUYER',
      token: json['token'] as String? ?? '',
    );
  }
}
