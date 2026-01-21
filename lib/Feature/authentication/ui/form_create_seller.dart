import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/product/ui/form_create_product_view.dart';
import 'package:herbal_app/main.dart';

class SellerProfileFormScreen extends StatefulWidget {
  const SellerProfileFormScreen({super.key});

  @override
  State<SellerProfileFormScreen> createState() =>
      _SellerProfileFormScreenState();
}

class _SellerProfileFormScreenState extends State<SellerProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _yearController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _productsController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _categoryController.dispose();
    _yearController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _descriptionController.dispose();
    _socialMediaController.dispose();
    _whatsappController.dispose();
    _productsController.dispose();
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
          'Daftar Akun Penjual',
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
          if (state is SellerProfileSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSuccessDialog(context, state.profile.id);
            });
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Bisnis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _businessNameController,
                        label: 'Nama Bisnis',
                        hint: 'Contoh: Toko Herbal Sehat',
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _categoryController,
                        label: 'Kategori Bisnis',
                        hint: 'Contoh: Herbal, Obat Tradisional',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _yearController,
                        label: 'Tahun Berdiri',
                        hint: 'Contoh: 2020',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Alamat Bisnis',
                        hint: 'Jalan, No, RT/RW',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _cityController,
                        label: 'Kota',
                        hint: 'Contoh: Jakarta',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _provinceController,
                        label: 'Provinsi',
                        hint: 'Contoh: DKI Jakarta',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Deskripsi Bisnis',
                        hint: 'Ceritakan tentang bisnis Anda',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Informasi Kontak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _productsController,
                        label: 'Produk/Layanan',
                        hint: 'Pisahkan dengan koma (,)',
                        maxLines: 3,
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
                                  'Daftar Sebagai Penjual',
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
              ),
              if (state is CreateProfileError)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // bloc.add(ResetSellerProfileEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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
      final products = _productsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final data = {
        'business_name': _businessNameController.text,
        'business_category': _categoryController.text.isEmpty
            ? null
            : _categoryController.text,
        'established_year': _yearController.text.isEmpty
            ? null
            : int.tryParse(_yearController.text),
        'business_address': _addressController.text.isEmpty
            ? null
            : _addressController.text,
        'city': _cityController.text.isEmpty ? null : _cityController.text,
        'province': _provinceController.text.isEmpty
            ? null
            : _provinceController.text,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'social_media_url': _socialMediaController.text.isEmpty
            ? null
            : _socialMediaController.text,
        'whatsapp_number': _whatsappController.text.isEmpty
            ? null
            : _whatsappController.text,
        'products_services': products.isEmpty ? null : products,
      };

      // Simulasi userId - ganti dengan user ID dari auth
      String userId = supabase.auth.currentUser!.id;

      bloc.add(CreateSellerProfileEvent(data: data, userId: userId));
    }
  }

  void _showSuccessDialog(BuildContext context, String sellerId) {
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
              'Akun penjual Anda berhasil didaftarkan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ProductFormScreen(
                        umkmId: sellerId,
                        isFirstProduct: true,
                      ),
                    ),
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
                  'Tambah Produk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 24),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).pop(); // Close dialog
            //       Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MainNavigation()),
            // ); // Close form
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.green[700],
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     child: const Text(
            //       'OK',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
