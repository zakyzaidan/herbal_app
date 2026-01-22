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
    String toString(dynamic v) => v?.toString() ?? '';

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

    return PractitionerProfile(
      id: toString(json['id']),
      userId: toString(json['user_id']),
      fullName: toString(json['full_name']),
      title: toString(json['title']),
      educationHistory: json['education_history']?.toString(),
      trainingInstitution: json['training_institution']?.toString(),
      practiceName: json['practice_name']?.toString(),
      practiceAddress: json['practice_address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      certificationNumber: json['certification_number']?.toString(),
      services: toStringList(json['services']),
      description: json['description']?.toString(),
      whatsappNumber: json['whatsapp_number']?.toString(),
      socialMediaUrl: json['social_media_url']?.toString(),
      profilePhoto: json['profile_photo']?.toString(),
      createdAt: toDate(json['created_at']),
      updatedAt: toDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
