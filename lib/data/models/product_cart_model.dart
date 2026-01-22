class ProductCartModel {
  final int id;
  final String? idSeller;
  final String? namaProduk;
  final int? harga;
  final String? namaSeller;
  final List<String>? imageUrl;

  ProductCartModel({
    required this.id,
    required this.idSeller,
    required this.namaProduk,
    required this.imageUrl,
    required this.harga,
    required this.namaSeller,
  });

  /// Digunakan untuk hasil JOIN Supabase (nested seller)
  factory ProductCartModel.fromSupabase(Map<String, dynamic> json) {
    final seller = json['seller'];

    final List<dynamic>? imagesDynamic = json['image_url'];
    final List<String>? images = imagesDynamic
        ?.map((e) => e.toString())
        .toList();

    return ProductCartModel(
      id: json['id'] as int,
      idSeller: seller?['id']?.toString(),
      namaProduk: json['nama_produk'] as String?,
      imageUrl: images,
      harga: json['harga'] as int?,
      namaSeller: seller?['nama_toko'] as String?,
    );
  }

  /// Digunakan untuk local storage / API non-join
  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? imagesDynamic = json['image_url'];
    final List<String>? images = imagesDynamic
        ?.map((e) => e.toString())
        .toList();

    return ProductCartModel(
      id: json['id'] as int,
      idSeller: json['id_seller'] as String?,
      namaProduk: json['nama_produk'] as String?,
      imageUrl: images,
      harga: json['harga'] as int?,
      namaSeller: json['nama_seller'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_seller': idSeller,
      'nama_produk': namaProduk,
      'image_url': imageUrl, // List<String> → PostgreSQL text[]
      'harga': harga,
      'nama_seller': namaSeller,
    };
  }
}
