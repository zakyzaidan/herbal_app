import 'dart:typed_data'; // Untuk Uint8List
import 'package:herbal_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Untuk mendapatkan XFile
import 'package:uuid/uuid.dart'; // Untuk nama file unik

class SupabaseStorageService {
  final Uuid _uuid = const Uuid();
  // Definisikan nama bucket Supabase Anda
  static const String _sellerBucket = 'seller-assets';

  /// Mengunggah data gambar (Uint8List) ke Supabase Storage.
  ///
  /// [fileData] adalah data gambar dalam format byte.
  /// [storagePath] adalah path/folder tujuan di dalam bucket.
  /// [fileExtension] adalah ekstensi file (misalnya 'jpg', 'png').
  Future<String> _uploadFile(
    Uint8List fileData,
    String storagePath,
    String fileExtension,
  ) async {
    // Buat nama file yang unik
    final fileName = '${_uuid.v4()}.$fileExtension';
    final fullPath = '$storagePath/$fileName';

    try {
      // 1. Lakukan upload menggunakan .uploadBinary
      await supabase.storage
          .from(_sellerBucket)
          .uploadBinary(
            fullPath,
            fileData,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              // Tentukan tipe konten berdasarkan ekstensi untuk tampilan yang benar
              contentType: 'image/$fileExtension',
            ),
          );

      // 2. Dapatkan Public URL dari file yang diunggah
      final publicUrl = supabase.storage
          .from(_sellerBucket)
          .getPublicUrl(fullPath);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Gagal mengunggah file ke Storage: ${e.message}');
    } catch (e) {
      throw Exception('Error tak terduga saat mengunggah file: $e');
    }
  }

  // --------------------------------------------------------------------------
  // MARK: - Public Upload Methods
  // --------------------------------------------------------------------------

  /// Mengunggah Logo UMKM.
  ///
  /// Akan disimpan dalam folder 'logos'.
  /// Mengembalikan URL publik gambar yang diunggah.
  Future<String> uploadLogo(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    // Panggil fungsi inti upload
    return _uploadFile(fileData, 'logos', fileExtension);
  }

  /// Mengunggah Gambar Produk.
  ///
  /// Akan disimpan dalam folder 'products'.
  /// Mengembalikan URL publik gambar yang diunggah.
  Future<String> uploadImgProduct(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    // Panggil fungsi inti upload
    return _uploadFile(fileData, 'products', fileExtension);
  }
}
