class SellerProfile {
  // Field-field yang wajib ada
  final String id;
  final String userId;
  final String businessName;

  // Field-field optional/lainnya
  final String? businessCategory;
  final int? establishedYear;
  final String? businessAddress;
  final String? city;
  final String? province;
  final String? description;
  final String? socialMediaUrl;
  final String? whatsappNumber;
  final List<String>? productsServices; // Sesuai dengan tipe _text di database
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? businessLogo;

  SellerProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    this.businessCategory,
    this.establishedYear,
    this.businessAddress,
    this.city,
    this.province,
    this.description,
    this.socialMediaUrl,
    this.whatsappNumber,
    this.productsServices,
    required this.createdAt,
    required this.updatedAt,
    this.businessLogo,
  });

  // Factory constructor untuk membuat objek dari Map (JSON dari Supabase)
  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    // Penanganan khusus untuk products_services yang merupakan array/list
    final List<dynamic>? productsDynamic = json['products_services'];
    final List<String>? products = productsDynamic?.cast<String>();

    return SellerProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      businessName: json['nama_toko'] as String,
      businessCategory: json['kategori_toko'] as String?,
      establishedYear: json['established_year'] as int?,
      businessAddress: json['alamat'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      description: json['description'] as String?,
      socialMediaUrl: json['social_media_url'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      productsServices: products,

      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      businessLogo: json['business_logo'] as String?,
    );
  }

  // Metode untuk mengonversi objek menjadi Map (untuk dikirim ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'business_category': businessCategory,
      'established_year': establishedYear,
      'business_address': businessAddress,
      'city': city,
      'province': province,
      'description': description,
      'social_media_url': socialMediaUrl,
      'whatsapp_number': whatsappNumber,
      'products_services':
          productsServices, // List<String> akan diubah jadi Array di DB
      'business_logo': businessLogo,
      // 'user_id': userId, // Jika membuat profil baru, user_id perlu diisi
    };
  }
}
