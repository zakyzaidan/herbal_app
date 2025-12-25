class UserRole {
  final String roleId;
  final String roleName;
  final bool isActive;

  UserRole({
    required this.roleId,
    required this.roleName,
    required this.isActive,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      roleId: json['role_id'],
      roleName: json['roles']['name'],
      isActive: json['is_active'],
    );
  }
}

class UserModel {
  final String id;
  final String username;
  final String email;
  final String photo;

  /// Semua role milik user
  final List<UserRole> roles;

  /// Mendapatkan role yang aktif
  UserRole? get activeRole {
    try {
      return roles.firstWhere((r) => r.isActive);
    } catch (e) {
      return null;
    }
  }

  /// Helper untuk cek role
  bool hasRole(String roleName) {
    return roles.any((r) => r.roleName.toLowerCase() == roleName.toLowerCase());
  }

  /// Cek apakah role tertentu sedang aktif
  bool isRoleActive(String roleName) {
    return activeRole?.roleName.toLowerCase() == roleName.toLowerCase();
  }

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.photo,
    required this.roles,
  });

  /// Factory untuk membuat model dari Supabase Query JOIN
  factory UserModel.fromSupabase({
    required Map<String, dynamic> userData,
    required List<Map<String, dynamic>> rolesData,
  }) {
    return UserModel(
      id: userData['id'],
      username: userData['username'] ?? "",
      email: userData['email'] ?? "",
      photo: userData['photo'] ?? "",
      roles: rolesData.map((e) => UserRole.fromJson(e)).toList(),
    );
  }
}
