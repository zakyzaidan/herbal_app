import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/services/supabase_storage_services.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditFormScreen extends StatefulWidget {
  final Product product;
  final String umkmId;

  const ProductEditFormScreen({
    super.key,
    required this.product,
    required this.umkmId,
  });

  @override
  State<ProductEditFormScreen> createState() => _ProductEditFormScreenState();
}

class _ProductEditFormScreenState extends State<ProductEditFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = SupabaseStorageService();

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiSingkatController;
  late TextEditingController _deskripsiLengkapController;
  late TextEditingController _khasiatController;
  late TextEditingController _kemasanController;
  late TextEditingController _aturanController;
  late TextEditingController _legalitasController;
  late TextEditingController _kandunganController;
  late TextEditingController _informasiController;
  late TextEditingController _kategoriController;

  List<String> _imageUrls = [];
  bool _isUploadingImages = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _imageUrls = List.from(widget.product.imageUrl ?? []);
  }

  void _initializeControllers() {
    _namaController = TextEditingController(text: widget.product.namaProduk);
    _hargaController = TextEditingController(
      text: widget.product.harga.toString(),
    );
    _deskripsiSingkatController = TextEditingController(
      text: widget.product.deskripsiSingkat ?? '',
    );
    _deskripsiLengkapController = TextEditingController(
      text: widget.product.deskripsiLengkap ?? '',
    );
    _khasiatController = TextEditingController(
      text: widget.product.khasiat ?? '',
    );
    _kemasanController = TextEditingController(
      text: widget.product.kemasan ?? '',
    );
    _aturanController = TextEditingController(
      text: widget.product.aturanPemakaian ?? '',
    );
    _legalitasController = TextEditingController(
      text: widget.product.legalitas ?? '',
    );
    _kandunganController = TextEditingController(
      text: widget.product.kandungan ?? '',
    );
    _informasiController = TextEditingController(
      text: widget.product.informasiPenting ?? '',
    );
    _kategoriController = TextEditingController(
      text: widget.product.kategori?.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiSingkatController.dispose();
    _deskripsiLengkapController.dispose();
    _khasiatController.dispose();
    _kemasanController.dispose();
    _aturanController.dispose();
    _legalitasController.dispose();
    _kandunganController.dispose();
    _informasiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    setState(() => _isUploadingImages = true);

    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        for (var image in images) {
          final url = await _storageService.uploadImgProduct(image);
          _imageUrls.add(url);
        }
        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${images.length} gambar berhasil diunggah'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isUploadingImages = false);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Produk',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Produk berhasil diupdate'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Dasar'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _namaController,
                    label: 'Nama Produk',
                    hint: 'Contoh: Jamu Kunyit Asam',
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _hargaController,
                    label: 'Harga',
                    hint: 'Contoh: 25000',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _deskripsiSingkatController,
                    label: 'Deskripsi Singkat',
                    hint: 'Deskripsi singkat produk (max 100 karakter)',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _kategoriController,
                    label: 'Kategori',
                    hint: 'Pisahkan dengan koma (,). Contoh: Jamu, Minuman',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Gambar Produk'),
                  const SizedBox(height: 16),
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Detail Produk'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _deskripsiLengkapController,
                    label: 'Deskripsi Lengkap',
                    hint: 'Jelaskan produk secara detail',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _khasiatController,
                    label: 'Khasiat',
                    hint: 'Sebutkan manfaat produk',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _kandunganController,
                    label: 'Kandungan',
                    hint: 'Bahan-bahan yang terkandung',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _kemasanController,
                    label: 'Kemasan',
                    hint: 'Contoh: Botol 250ml',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _aturanController,
                    label: 'Aturan Pemakaian',
                    hint: 'Cara menggunakan produk',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _legalitasController,
                    label: 'Legalitas',
                    hint: 'Nomor PIRT, BPOM, dll',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _informasiController,
                    label: 'Informasi Penting',
                    hint: 'Peringatan atau informasi tambahan',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (isLoading || _isUploadingImages)
                          ? null
                          : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: (isLoading || _isUploadingImages)
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
                              'Simpan Perubahan',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUrls.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageUrls[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _isUploadingImages ? null : _pickImages,
          icon: _isUploadingImages
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_photo_alternate),
          label: Text(_isUploadingImages ? 'Mengunggah...' : 'Tambah Gambar'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload gambar produk (maksimal 5 gambar)',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_imageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimal tambahkan 1 gambar produk'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final kategori = _kategoriController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final updatedProduct = Product(
        id: widget.product.id,
        umkmId: widget.umkmId,
        namaProduk: _namaController.text,
        harga: int.tryParse(_hargaController.text) ?? 0,
        deskripsiSingkat: _deskripsiSingkatController.text.isEmpty
            ? null
            : _deskripsiSingkatController.text,
        deskripsiLengkap: _deskripsiLengkapController.text.isEmpty
            ? null
            : _deskripsiLengkapController.text,
        khasiat: _khasiatController.text.isEmpty
            ? null
            : _khasiatController.text,
        kemasan: _kemasanController.text.isEmpty
            ? null
            : _kemasanController.text,
        aturanPemakaian: _aturanController.text.isEmpty
            ? null
            : _aturanController.text,
        legalitas: _legalitasController.text.isEmpty
            ? null
            : _legalitasController.text,
        kandungan: _kandunganController.text.isEmpty
            ? null
            : _kandunganController.text,
        informasiPenting: _informasiController.text.isEmpty
            ? null
            : _informasiController.text,
        imageUrl: _imageUrls,
        kategori: kategori.isEmpty ? null : kategori,
        createdAt: widget.product.createdAt,
        updatedAt: DateTime.now(),
      );

      context.read<ProductBloc>().add(
        UpdateProductEvent(widget.product.id, updatedProduct),
      );
    }
  }
}
