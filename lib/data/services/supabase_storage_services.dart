import 'dart:typed_data'; // Untuk Uint8List
import 'package:herbal_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Untuk mendapatkan XFile
import 'package:uuid/uuid.dart'; // Untuk nama file unik

class SupabaseStorageService {
  final Uuid _uuid = const Uuid();

  // Definisikan nama bucket Supabase
  static const String _sellerBucket = 'seller-assets';
  static const String _practitionerBucket = 'practitioner-assets';

  /// Mengunggah data gambar (Uint8List) ke Supabase Storage.
  ///
  /// [fileData] adalah data gambar dalam format byte.
  /// [bucketName] adalah nama bucket tujuan.
  /// [storagePath] adalah path/folder tujuan di dalam bucket.
  /// [fileExtension] adalah ekstensi file (misalnya 'jpg', 'png').
  Future<String> _uploadFile(
    Uint8List fileData,
    String bucketName,
    String storagePath,
    String fileExtension,
  ) async {
    // Buat nama file yang unik
    final fileName = '${_uuid.v4()}.$fileExtension';
    final fullPath = '$storagePath/$fileName';

    try {
      // 1. Lakukan upload menggunakan .uploadBinary
      await supabase.storage
          .from(bucketName)
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
          .from(bucketName)
          .getPublicUrl(fullPath);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Gagal mengunggah file ke Storage: ${e.message}');
    } catch (e) {
      throw Exception('Error tak terduga saat mengunggah file: $e');
    }
  }

  // --------------------------------------------------------------------------
  // MARK: - Seller/UMKM Upload Methods
  // --------------------------------------------------------------------------

  /// Mengunggah Logo UMKM.
  ///
  /// Akan disimpan dalam folder 'logos' di bucket 'seller-assets'.
  /// Mengembalikan URL publik gambar yang diunggah.
  Future<String> uploadLogo(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    return _uploadFile(fileData, _sellerBucket, 'logos', fileExtension);
  }

  /// Mengunggah Gambar Produk.
  ///
  /// Akan disimpan dalam folder 'products' di bucket 'seller-assets'.
  /// Mengembalikan URL publik gambar yang diunggah.
  Future<String> uploadImgProduct(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    return _uploadFile(fileData, _sellerBucket, 'products', fileExtension);
  }

  // --------------------------------------------------------------------------
  // MARK: - Practitioner Upload Methods
  // --------------------------------------------------------------------------

  /// Mengunggah Foto Profil Praktisi.
  ///
  /// Akan disimpan dalam folder 'profile-photos' di bucket 'practitioner-assets'.
  /// Mengembalikan URL publik gambar yang diunggah.
  Future<String> uploadProfilePhoto(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    return _uploadFile(
      fileData,
      _practitionerBucket,
      'profile-photos',
      fileExtension,
    );
  }

  /// Mengunggah Sertifikat Praktisi.
  ///
  /// Akan disimpan dalam folder 'certificates' di bucket 'practitioner-assets'.
  /// Mengembalikan URL publik file yang diunggah.
  Future<String> uploadCertificate(XFile pickedFile) async {
    final fileData = await pickedFile.readAsBytes();
    final fileExtension = pickedFile.path.split('.').last;

    return _uploadFile(
      fileData,
      _practitionerBucket,
      'certificates',
      fileExtension,
    );
  }
}
