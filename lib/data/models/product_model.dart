// product.dart

class Product {
  // Field-field utama
  final int id; // int4
  final String umkmId; // uuid - foreign key ke umkm_profiles
  final String namaProduk; // text
  final int harga; // text

  // Field-field detail produk
  final String? deskripsiSingkat; // text
  final String? deskripsiLengkap; // text
  final String? khasiat; // text
  final String? kemasan; // text
  final String? aturanPemakaian; // text
  final String? legalitas; // text
  final String? kandungan; // text
  final String? informasiPenting; // text

  // Array dan Timestamp
  final List<String>? imageUrl; // _text (array of strings)
  final List<String>? kategori; // _text (array of strings)
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  Product({
    required this.id,
    required this.umkmId,
    required this.namaProduk,
    required this.harga,
    this.deskripsiSingkat,
    this.deskripsiLengkap,
    this.khasiat,
    this.kemasan,
    this.aturanPemakaian,
    this.legalitas,
    this.kandungan,
    this.informasiPenting,
    this.imageUrl,
    this.kategori,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor untuk membuat objek dari Map (JSON dari Supabase)
  factory Product.fromJson(Map<String, dynamic> json) {
    // Penanganan khusus untuk array/list
    final List<dynamic>? imagesDynamic = json['image_url'];
    final List<String>? images = imagesDynamic?.cast<String>();

    final List<dynamic>? categoriesDynamic = json['kategori'];
    final List<String>? categories = categoriesDynamic?.cast<String>();

    return Product(
      id: json['id'] as int,
      umkmId: json['umkm_id'] as String,
      namaProduk: json['nama_produk'] as String,
      harga: json['harga'] as int,
      deskripsiSingkat: json['deskripsi_singkat'] as String?,
      deskripsiLengkap: json['deskripsi_lengkap'] as String?,
      khasiat: json['khasiat'] as String?,
      kemasan: json['kemasan'] as String?,
      aturanPemakaian: json['aturan_pemakaian'] as String?,
      legalitas: json['legalitas'] as String?,
      kandungan: json['kandungan'] as String?,
      informasiPenting: json['informasi_penting'] as String?,
      imageUrl: images,
      kategori: categories,
      // Supabase biasanya mengembalikan timestamp sebagai string
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Metode untuk mengonversi objek menjadi Map (untuk dikirim ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      // id, created_at, dan updated_at biasanya dikelola oleh database
      'umkm_id': umkmId,
      'nama_produk': namaProduk,
      'harga': harga,
      'deskripsi_singkat': deskripsiSingkat,
      'deskripsi_lengkap': deskripsiLengkap,
      'khasiat': khasiat,
      'kemasan': kemasan,
      'aturan_pemakaian': aturanPemakaian,
      'legalitas': legalitas,
      'kandungan': kandungan,
      'informasi_penting': informasiPenting,
      'image_url': imageUrl,
      'kategori': kategori,
    };
  }
}
