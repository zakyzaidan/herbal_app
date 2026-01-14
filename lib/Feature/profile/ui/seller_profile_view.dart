// ============================================================================
// SELLER PROFILE (Penjual)
// ============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:herbal_app/Feature/product/ui/form_create_product_view.dart';
import 'package:herbal_app/Feature/settings/ui/settings_view.dart';
import 'package:herbal_app/components/produk_cart.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/models/user_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';

class SellerProfileView extends StatefulWidget {
  final UserModel user;

  const SellerProfileView({super.key, required this.user});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView>
    with SingleTickerProviderStateMixin {
  final SellerServices _sellerServices = SellerServices();
  late TabController _tabController;
  SellerProfile? _sellerProfile;
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSellerData();
  }

  Future<void> _loadSellerData() async {
    try {
      final profile = await _sellerServices.getProfileByUserId(widget.user.id);
      if (profile != null) {
        final products = await _sellerServices.getProductsByUmkmId(profile.id);
        setState(() {
          _sellerProfile = profile;
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading seller data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A400C),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: _buildSellerCard(),
                          ),
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildStoreTab(),
                                _buildProductsTab(),
                                _buildForumTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add product
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductFormScreen(
                umkmId: _sellerProfile!.id,
                isFirstProduct: false,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        backgroundColor: const Color.fromARGB(255, 48, 172, 53),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Akun Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsView()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.amber,
                backgroundImage: _sellerProfile?.businessLogo != null
                    ? NetworkImage(_sellerProfile!.businessLogo!)
                    : null,
                child: _sellerProfile?.businessLogo == null
                    ? Text(
                        _sellerProfile?.businessName[0].toUpperCase() ?? 'T',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sellerProfile?.businessName ?? 'Toko',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Penjual',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
              ),
            ],
          ),
          if (_sellerProfile?.description != null) ...[
            const SizedBox(height: 16),
            Text(
              _sellerProfile!.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF0A400C),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF0A400C),
        tabs: const [
          Tab(text: 'Toko'),
          Tab(text: 'Produk'),
          Tab(text: 'Postingan Forum'),
        ],
      ),
    );
  }

  Widget _buildStoreTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_sellerProfile?.businessAddress != null)
            _buildInfoRow('Alamat', _sellerProfile!.businessAddress!),
          if (_sellerProfile?.city != null)
            _buildInfoRow('Kota', _sellerProfile!.city!),
          if (_sellerProfile?.whatsappNumber != null)
            _buildInfoRow('WhatsApp', _sellerProfile!.whatsappNumber!),
          if (_sellerProfile?.establishedYear != null)
            _buildInfoRow(
              'Tahun Berdiri',
              _sellerProfile!.establishedYear.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada produk',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProdukCart(product: product);
      },
    );
  }

  Widget _buildForumTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada postingan',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
