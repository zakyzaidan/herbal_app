import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/services/supabase_storage_services.dart';
import 'package:herbal_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerServices {
  final String _sellerTableName = 'umkm_profiles';
  final String _productTableName = 'products';
  final SupabaseStorageService _storageService = SupabaseStorageService();

  // --- 1. Mengambil Data Profil Seller berdasarkan User ID ---
  Future<SellerProfile?> getProfileByUserId(String userId) async {
    try {
      final response = await supabase
          .from(_sellerTableName)
          .select()
          .eq('user_id', userId)
          .limit(1)
          .single(); // Mengambil satu baris atau error jika lebih dari satu

      // Jika data ditemukan
      return SellerProfile.fromJson(response);
    } on PostgrestException catch (e) {
      // Jika profil tidak ditemukan (biasanya PostgrestException dengan code 406/204)
      if (e.message.contains('rows returned')) {
        return null;
      }
      // Jika terjadi error Supabase lainnya
      throw Exception('Gagal mengambil profil: ${e.message}');
    } catch (e) {
      // Error umum (misalnya jaringan)
      throw Exception('Terjadi error saat mengambil profil: $e');
    }
  }

  // --- 2. Menyimpan/Membuat Profil UMKM Baru ---
  Future<SellerProfile> createProfile(Map<String, dynamic> data, String userId) async {
    try {
      // Pastikan 'user_id' sudah diisi di objek 'profile' sebelum memanggil service
      final PostgrestMap response = await supabase
          .from(_sellerTableName)
          .insert({...data, 'user_id': userId})
          .select().single(); // Mengembalikan data yang baru saja di-insert

      // Supabase insert mengembalikan list of maps, ambil item pertama
      return SellerProfile.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat profil baru: $e');
    }
  }

  // --- 3. Memperbarui Profil UMKM ---
  Future<SellerProfile> updateProfile(
    String id,
    SellerProfile updatedProfile,
  ) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from(_sellerTableName)
          // Mengupdate data menggunakan toJson(), mengabaikan id dan created_at
          .update(updatedProfile.toJson())
          .eq('id', id)
          .select(); // Mengembalikan data yang telah diupdate

      // Supabase update mengembalikan list of maps, ambil item pertama
      return SellerProfile.fromJson(response.first);
    } catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }

  // Fungsi Alur Upload Logo UMKM
  Future<String?> handleLogoUpload() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      // Panggil service untuk mengunggah logo
      final String publicUrl = await _storageService.uploadLogo(file);

      // Setelah berhasil diunggah, simpan URL ini ke database
      // Panggil UmkmProfileService Anda di sini:
      // await UmkmProfileService().updateProfile(userId, {'business_logo': publicUrl});

      print('Logo berhasil diunggah. URL: $publicUrl');
      return publicUrl;
    }
    return null;
  }

  /// ---------------------------------------------------
  /// Product Services
  /// ---------------------------------------------------

  // --- 1. Mendapatkan Semua Produk untuk Suatu UMKM ---
  Future<List<Product>> getProductsByUmkmId(String umkmId) async {
    try {
      final response = await supabase
          .from(_productTableName)
          .select()
          .eq('umkm_id', umkmId) // Filter berdasarkan ID UMKM
          .order('created_at', ascending: false); // Urutkan dari terbaru

      // Mapping hasil List<Map<String, dynamic>> menjadi List<Product>
      return (response as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar produk: $e');
    }
  }

  // --- 2. Mendapatkan Semua Produk untuk Suatu UMKM ---
  Future<List<Product>> getNewestProducts(String umkmId) async {
    try {
      final response = await supabase
          .from(_productTableName)
          .select()
          .order('created_at', ascending: false)
          .limit(15);

      // Mapping hasil List<Map<String, dynamic>> menjadi List<Product>
      return (response as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar produk: $e');
    }
  }

  // --- 2. Mendapatkan Detail Satu Produk berdasarkan ID Produk ---
  Future<Product?> getProductById(int productId) async {
    try {
      final response = await supabase
          .from(_productTableName)
          .select()
          .eq('id', productId)
          .limit(1)
          .single();

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.message.contains('rows returned')) {
        return null;
      }
      throw Exception('Gagal mengambil detail produk: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi error saat mengambil produk: $e');
    }
  }

  // --- 3. Menambahkan Produk Baru ---
  Future<Product> addProduct(Product product) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from(_productTableName)
          .insert(product.toJson())
          .select(); // Mengembalikan data yang baru saja di-insert

      return Product.fromJson(response.first);
    } catch (e) {
      throw Exception('Gagal menambahkan produk baru: $e');
    }
  }

  // --- 4. Memperbarui Produk yang Sudah Ada ---
  Future<Product> updateProduct(int id, Product updatedProduct) async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from(_productTableName)
          .update(updatedProduct.toJson())
          .eq('id', id)
          .select(); // Mengembalikan data yang telah diupdate

      return Product.fromJson(response.first);
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  // --- 5. Menghapus Produk ---
  Future<void> deleteProduct(int id) async {
    try {
      await supabase.from(_productTableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
