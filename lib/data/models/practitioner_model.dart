// lib/data/models/practitioner_model.dart

class PractitionerProfile {
  final String id;
  final String userId;
  final String fullName;
  final String title; // Gelar praktisi

  // Informasi Pendidikan/Pelatihan
  final String? educationHistory; // Riwayat Pendidikan
  final String? trainingInstitution; // Institusi pelatihan

  // Tempat Praktik
  final String? practiceName; // Nama tempat praktik
  final String? practiceAddress;
  final String? city;
  final String? province;

  // Sertifikasi
  final String? certificationNumber; // Nomor surat izin praktik

  // Layanan
  final List<String>? services; // List layanan yang ditawarkan

  // Deskripsi
  final String? description;

  // Kontak
  final String? whatsappNumber;
  final String? socialMediaUrl;

  // Profile Image
  final String? profilePhoto;

  final DateTime createdAt;
  final DateTime updatedAt;

  PractitionerProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.title,
    this.educationHistory,
    this.trainingInstitution,
    this.practiceName,
    this.practiceAddress,
    this.city,
    this.province,
    this.certificationNumber,
    this.services,
    this.description,
    this.whatsappNumber,
    this.socialMediaUrl,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PractitionerProfile.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? servicesDynamic = json['services'];
    final List<String>? services = servicesDynamic?.cast<String>();

    return PractitionerProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      title: json['title'] as String,
      educationHistory: json['education_history'] as String?,
      trainingInstitution: json['training_institution'] as String?,
      practiceName: json['practice_name'] as String?,
      practiceAddress: json['practice_address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      certificationNumber: json['certification_number'] as String?,
      services: services,
      description: json['description'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      socialMediaUrl: json['social_media_url'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'title': title,
      'education_history': educationHistory,
      'training_institution': trainingInstitution,
      'practice_name': practiceName,
      'practice_address': practiceAddress,
      'city': city,
      'province': province,
      'certification_number': certificationNumber,
      'services': services,
      'description': description,
      'whatsapp_number': whatsappNumber,
      'social_media_url': socialMediaUrl,
      'profile_photo': profilePhoto,
    };
  }
}
