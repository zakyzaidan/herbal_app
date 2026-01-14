// lib/Feature/authentication/ui/form_create_practitioner.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/data/services/supabase_storage_services.dart';
import 'package:herbal_app/main.dart';
import 'package:herbal_app/main_navigation.dart';
import 'package:image_picker/image_picker.dart';

class PractitionerProfileFormScreen extends StatefulWidget {
  const PractitionerProfileFormScreen({Key? key}) : super(key: key);

  @override
  State<PractitionerProfileFormScreen> createState() =>
      _PractitionerProfileFormScreenState();
}

class _PractitionerProfileFormScreenState
    extends State<PractitionerProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = SupabaseStorageService();

  final _fullNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _educationController = TextEditingController();
  final _institutionController = TextEditingController();
  final _practiceNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _certificationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _servicesController = TextEditingController();

  String? _profilePhotoUrl;
  bool _isUploadingPhoto = false;

  Future<void> _pickProfilePhoto() async {
    setState(() => _isUploadingPhoto = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final url = await _storageService.uploadProfilePhoto(image);
        setState(() {
          _profilePhotoUrl = url;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto profil berhasil diunggah'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isUploadingPhoto = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _titleController.dispose();
    _educationController.dispose();
    _institutionController.dispose();
    _practiceNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _certificationController.dispose();
    _descriptionController.dispose();
    _whatsappController.dispose();
    _socialMediaController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Akun Praktisi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is PractitionerProfileSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSuccessDialog(context);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                image: _profilePhotoUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_profilePhotoUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _profilePhotoUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[400],
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploadingPhoto
                                    ? null
                                    : _pickProfilePhoto,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: _isUploadingPhoto
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Foto Profil',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Informasi Pribadi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Nama Lengkap',
                    hint: 'Contoh: Dr. Ahmad Ridwan',
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Gelar/Title',
                    hint: 'Contoh: Dokter Spesialis Akupunktur Medik',
                    isRequired: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pendidikan & Pelatihan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _educationController,
                    label: 'Riwayat Pendidikan/Pelatihan',
                    hint: 'Contoh: S1 Kedokteran - Unjani',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _institutionController,
                    label: 'Institusi Pelatihan',
                    hint: 'Nama institusi tempat pelatihan',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tempat Praktik',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _practiceNameController,
                    label: 'Nama Tempat Praktik',
                    hint: 'Contoh: Rumah Terapi ABC',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Alamat Praktik',
                    hint: 'Jalan, No, RT/RW',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cityController,
                    label: 'Kota',
                    hint: 'Contoh: Bandung',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _provinceController,
                    label: 'Provinsi',
                    hint: 'Contoh: Jawa Barat',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sertifikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _certificationController,
                    label: 'Sertifikasi - Surat Izin Praktik',
                    hint: 'Nomor sertifikasi atau izin praktik',
                    isRequired: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Layanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _servicesController,
                    label: 'Layanan yang Ditawarkan',
                    hint:
                        'Pisahkan dengan koma (,). Contoh: Akupunktur, Bekam, Penyedia Ramuan',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Deskripsi & Kontak',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Deskripsi',
                    hint: 'Ceritakan tentang keahlian dan pengalaman Anda',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _whatsappController,
                    label: 'Nomor WhatsApp',
                    hint: '08xxxxxxxxxx',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _socialMediaController,
                    label: 'Social Media / Website',
                    hint: 'Instagram, Facebook, atau Website',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is CreateProfileLoading
                          ? null
                          : () => _submitForm(context, bloc),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is CreateProfileLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Daftar Sebagai Praktisi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[700]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label harus diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitForm(BuildContext context, AuthBloc bloc) {
    if (_formKey.currentState!.validate()) {
      final services = _servicesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final data = {
        'full_name': _fullNameController.text,
        'title': _titleController.text,
        'education_history': _educationController.text.isEmpty
            ? null
            : _educationController.text,
        'training_institution': _institutionController.text.isEmpty
            ? null
            : _institutionController.text,
        'practice_name': _practiceNameController.text.isEmpty
            ? null
            : _practiceNameController.text,
        'practice_address': _addressController.text.isEmpty
            ? null
            : _addressController.text,
        'city': _cityController.text.isEmpty ? null : _cityController.text,
        'province': _provinceController.text.isEmpty
            ? null
            : _provinceController.text,
        'certification_number': _certificationController.text,
        'services': services.isEmpty ? null : services,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'whatsapp_number': _whatsappController.text.isEmpty
            ? null
            : _whatsappController.text,
        'social_media_url': _socialMediaController.text.isEmpty
            ? null
            : _socialMediaController.text,
        'profile_photo': _profilePhotoUrl,
      };

      String userId = supabase.auth.currentUser!.id;

      bloc.add(CreatePractitionerProfileEvent(data: data, userId: userId));
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Berhasil!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Akun praktisi Anda berhasil didaftarkan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
