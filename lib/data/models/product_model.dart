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
    int toInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    DateTime toDate(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    List<String>? toStringList(dynamic v) {
      if (v is List) {
        return v.whereType<String>().toList();
      }
      return null;
    }

    return Product(
      id: toInt(json['id']),
      umkmId: json['umkm_id']?.toString() ?? '',
      namaProduk: json['nama_produk']?.toString() ?? '',
      harga: toInt(json['harga']),
      deskripsiSingkat: json['deskripsi_singkat']?.toString(),
      deskripsiLengkap: json['deskripsi_lengkap']?.toString(),
      khasiat: json['khasiat']?.toString(),
      kemasan: json['kemasan']?.toString(),
      aturanPemakaian: json['aturan_pemakaian']?.toString(),
      legalitas: json['legalitas']?.toString(),
      kandungan: json['kandungan']?.toString(),
      informasiPenting: json['informasi_penting']?.toString(),
      imageUrl: toStringList(json['image_url']),
      kategori: toStringList(json['kategori']),
      createdAt: toDate(json['created_at']),
      updatedAt: toDate(json['updated_at']),
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
