// lib/data/repositories/practitioner_repository.dart

import 'dart:convert';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PractitionerRepository {
  final PractitionerServices _practitionerServices;
  final SharedPreferences _prefs;

  // Cache keys
  static const String _allPractitionersKey = 'cached_all_practitioners';
  static const String _allPractitionersTimestampKey =
      'cached_all_practitioners_timestamp';

  // Cache duration (10 minutes - practitioners change less frequently)
  static const Duration _cacheDuration = Duration(minutes: 10);

  PractitionerRepository(this._practitionerServices, this._prefs);

  /// Get all practitioners with caching
  Future<List<PractitionerProfile>> getAllPractitioners({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _getCachedPractitioners(
        _allPractitionersKey,
        _allPractitionersTimestampKey,
      );
      if (cached != null) {
        return cached;
      }
    }

    try {
      final practitioners = await _practitionerServices.getAllPractitioners();
      await _cachePractitioners(
        practitioners,
        _allPractitionersKey,
        _allPractitionersTimestampKey,
      );
      return practitioners;
    } catch (e) {
      final cached = _getCachedPractitioners(
        _allPractitionersKey,
        _allPractitionersTimestampKey,
        ignoreExpiry: true,
      );
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  /// Get practitioner by user ID
  Future<PractitionerProfile?> getProfileByUserId(String userId) async {
    return await _practitionerServices.getProfileByUserId(userId);
  }

  /// Get practitioner by ID
  Future<PractitionerProfile?> getProfileById(String id) async {
    return await _practitionerServices.getProfileById(id);
  }

  /// Create practitioner profile and clear cache
  Future<PractitionerProfile> createProfile(
    Map<String, dynamic> data,
    String userId,
  ) async {
    final profile = await _practitionerServices.createProfile(data, userId);
    await _clearPractitionerCaches();
    return profile;
  }

  /// Update practitioner profile and clear cache
  Future<PractitionerProfile> updateProfile(
    String id,
    PractitionerProfile profile,
  ) async {
    final updated = await _practitionerServices.updateProfile(id, profile);
    await _clearPractitionerCaches();
    return updated;
  }

  /// Search practitioners with caching
  Future<List<PractitionerProfile>> searchPractitioners({
    required String query,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'cached_search_$query';
    final timestampKey = '${cacheKey}_timestamp';

    if (!forceRefresh) {
      final cached = _getCachedPractitioners(cacheKey, timestampKey);
      if (cached != null) {
        return cached;
      }
    }

    try {
      final results = await _practitionerServices.searchPractitioners(query);
      await _cachePractitioners(results, cacheKey, timestampKey);
      return results;
    } catch (e) {
      final cached = _getCachedPractitioners(
        cacheKey,
        timestampKey,
        ignoreExpiry: true,
      );
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  // ========== Private Helper Methods ==========

  List<PractitionerProfile>? _getCachedPractitioners(
    String cacheKey,
    String timestampKey, {
    bool ignoreExpiry = false,
  }) {
    try {
      final cachedJson = _prefs.getString(cacheKey);
      final timestamp = _prefs.getInt(timestampKey);

      if (cachedJson == null || timestamp == null) return null;

      if (!ignoreExpiry) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheTime) > _cacheDuration) {
          return null;
        }
      }

      final List<dynamic> jsonList = json.decode(cachedJson);
      return jsonList
          .map((json) => PractitionerProfile.fromJson(json))
          .toList();
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }

  Future<void> _cachePractitioners(
    List<PractitionerProfile> practitioners,
    String cacheKey,
    String timestampKey,
  ) async {
    try {
      final jsonList = practitioners.map((p) => p.toJson()).toList();
      await _prefs.setString(cacheKey, json.encode(jsonList));
      await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching practitioners: $e');
    }
  }

  Future<void> _clearPractitionerCaches() async {
    await _prefs.remove(_allPractitionersKey);
    await _prefs.remove(_allPractitionersTimestampKey);

    // Clear search caches
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cached_search_')) {
        await _prefs.remove(key);
      }
    }
  }

  /// Clear all caches
  Future<void> clearAllCaches() async {
    await _clearPractitionerCaches();
  }
}
