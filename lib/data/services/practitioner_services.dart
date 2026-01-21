// lib/data/services/practitioner_services.dart

import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PractitionerServices {
  final String _tableName = 'practitioner_profiles';

  // Mengambil profil praktisi berdasarkan User ID
  Future<PractitionerProfile?> getProfileByUserId(String userId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .limit(1)
          .single();

      return PractitionerProfile.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.message.contains('rows returned')) {
        return null;
      }
      throw Exception('Gagal mengambil profil: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi error saat mengambil profil: $e');
    }
  }

  // Membuat profil praktisi baru
  Future<PractitionerProfile> createProfile(
    Map<String, dynamic> data,
    String userId,
  ) async {
    try {
      final PostgrestMap response = await supabase
          .from(_tableName)
          .insert({...data, 'user_id': userId})
          .select()
          .single();

      return PractitionerProfile.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat profil baru: $e');
    }
  }

  // Memperbarui profil praktisi
  Future<PractitionerProfile> updateProfile(
    String id,
    PractitionerProfile updatedProfile,
  ) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from(_tableName)
          .update(updatedProfile.toJson())
          .eq('id', id)
          .select();

      return PractitionerProfile.fromJson(response.first);
    } catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }

  // Mengambil semua praktisi (untuk list)
  Future<List<PractitionerProfile>> getAllPractitioners() async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map(
            (json) =>
                PractitionerProfile.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar praktisi: $e');
    }
  }

  // Mengambil praktisi berdasarkan ID
  Future<PractitionerProfile?> getProfileById(String id) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .limit(1)
          .single();

      return PractitionerProfile.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.message.contains('rows returned')) {
        return null;
      }
      throw Exception('Gagal mengambil profil: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi error saat mengambil profil: $e');
    }
  }

  // Mencari praktisi berdasarkan query (mencari di nama ATAU layanan)
  Future<List<PractitionerProfile>> searchPractitioners(
    String queryText,
  ) async {
    try {
      // 1. Buat filter string untuk operator OR
      // 'full_name.ilike.%$queryText%,services.cs.{$queryText}'
      // ilike: case-insensitive search untuk nama
      // cs (contains): mengecek apakah array 'services' mengandung queryText
      final String orFilter =
          'full_name.ilike.%$queryText%,services.cs.{$queryText}';

      final response = await supabase
          .from(_tableName)
          .select()
          .or(orFilter) // Menggabungkan kedua kondisi dengan OR
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map(
            (json) =>
                PractitionerProfile.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari praktisi: $e');
    }
  }
}
