// ============================================================================
// ROLE MANAGEMENT SERVICE
// ============================================================================

import 'package:herbal_app/data/models/user_model.dart';
import 'package:herbal_app/main.dart';

class RoleService {
  String? get _userId => supabase.auth.currentUser?.id;

  /// Mendapatkan user dengan semua rolenya
  Future<UserModel?> getUser() async {
    if (_userId == null) return null;

    try {
      final user = await supabase
          .from('user_profiles')
          .select()
          .eq('id', _userId!)
          .single();

      final roles = await supabase
          .from('user_roles')
          .select('role_id, is_active, roles(name)')
          .eq('user_id', _userId!);

      return UserModel.fromSupabase(
        userData: user,
        rolesData: List<Map<String, dynamic>>.from(roles),
      );
    } catch (e) {
      return null;
    }
  }

  /// Mendapatkan role aktif saat ini
  Future<UserRole?> getActiveRole() async {
    final user = await getUser();
    return user?.activeRole;
  }

  /// Switch role berdasarkan nama role
  Future<bool> switchRole(String roleName) async {
    if (_userId == null) return false;

    try {
      // Cari role_id berdasarkan nama
      final role = await supabase
          .from('roles')
          .select('id')
          .ilike('name', roleName)
          .single();

      // Cek apakah user punya role ini
      final userRole = await supabase
          .from('user_roles')
          .select('id')
          .eq('user_id', _userId!)
          .eq('role_id', role['id'])
          .maybeSingle();

      if (userRole == null) {
        return false;
      }

      // Nonaktifkan semua role, aktifkan yang dipilih
      await supabase
          .from('user_roles')
          .update({'is_active': false})
          .eq('user_id', _userId!);

      await supabase
          .from('user_roles')
          .update({'is_active': true})
          .eq('user_id', _userId!)
          .eq('role_id', role['id']);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Assign role ke user (untuk registrasi atau upgrade role)
  Future<bool> assignRole(String roleName, {bool setActive = false}) async {
    if (_userId == null) return false;

    try {
      // Cari role_id
      final role = await supabase
          .from('roles')
          .select('id')
          .ilike('name', roleName)
          .single();

      // Cek apakah sudah punya role ini
      final existing = await supabase
          .from('user_roles')
          .select('id')
          .eq('user_id', _userId!)
          .eq('role_id', role['id'])
          .maybeSingle();

      if (existing != null) {
        return false;
      }

      // Jika set active, nonaktifkan yang lain
      if (setActive) {
        await supabase
            .from('user_roles')
            .update({'is_active': false})
            .eq('user_id', _userId!);
      }

      // Tambahkan role baru
      await supabase.from('user_roles').insert({
        'user_id': _userId,
        'role_id': role['id'],
        'is_active': setActive,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Stream untuk listen perubahan role
  Stream<UserModel?> watchRoles() {
    if (_userId == null) return Stream.value(null);

    return supabase
        .from('user_roles')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId!)
        .asyncMap((_) => getUser());
  }
}
