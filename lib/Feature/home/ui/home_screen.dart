import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/home/bloc/home_bloc.dart';
import 'package:herbal_app/Feature/home/ui/home_img_slider.dart';
import 'package:herbal_app/components/produk_cart.dart';
import 'package:herbal_app/components/practitioner_card_vertical.dart';
import 'package:herbal_app/components/search_bar_widget.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data ketika screen pertama kali dibuka
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar & Favorite Icon
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(child: searchBar(() {}, "Cari produk herbal...")),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Image Slider
              const HomeImgSlider(),
              const SizedBox(height: 24),

              // Produk Terbaru Section
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    return Column(
                      children: [
                        // Produk Terbaru
                        _buildProductSection(
                          context,
                          'Produk Terbaru',
                          state.products,
                        ),
                        const SizedBox(height: 32),

                        // Praktisi Section
                        _buildPractitionerSection(
                          context,
                          'Praktisi',
                          state.practitioners,
                        ),
                        const SizedBox(height: 32),

                        // Kategori Produk (Dinamis dari database)
                        _buildCategorySection(
                          context,
                          state.categories,
                          state.selectedCategory,
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              'Error: ${state.message}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(
                                  LoadHomeDataEvent(),
                                );
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection(
    BuildContext context,
    String title,
    List<Product> products,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all products
                },
                child: Text(
                  'Lebih banyak',
                  style: TextStyle(color: Colors.green[700], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: products.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada produk',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: products.length > 10 ? 10 : products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 160,
                      child: ProdukCart(product: products[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPractitionerSection(
    BuildContext context,
    String title,
    List<PractitionerProfile> practitioners,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all practitioners
                },
                child: Text(
                  'Lebih banyak',
                  style: TextStyle(color: Colors.green[700], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: practitioners.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada praktisi',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: practitioners.length > 10
                      ? 10
                      : practitioners.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 180,
                      child: PractitionerCardVertical(
                        practitioner: practitioners[index],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    List<String> categories,
    String? selectedCategory,
  ) {
    // Jika tidak ada kategori dari database
    if (categories.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Kategori Produk',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Belum ada kategori produk',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      );
    }

    // Pisahkan kategori menjadi 2 baris
    final int itemsPerRow = (categories.length / 2).ceil();
    final List<String> firstRow = categories.take(itemsPerRow).toList();
    final List<String> secondRow = categories.skip(itemsPerRow).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Kategori Produk',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),

        // First row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: firstRow.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    context.read<HomeBloc>().add(SelectCategoryEvent(category));

                    // Show snackbar untuk coming soon
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coming soon: Filter produk $category'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  backgroundColor: isSelected
                      ? const Color(0xFF0A400C)
                      : Colors.green[100],
                  selectedColor: const Color(0xFF0A400C),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.green[900],
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Second row (jika ada)
        if (secondRow.isNotEmpty) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: secondRow.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      context.read<HomeBloc>().add(
                        SelectCategoryEvent(category),
                      );

                      // Show snackbar untuk coming soon
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Coming soon: Filter produk $category'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    backgroundColor: isSelected
                        ? const Color(0xFF0A400C)
                        : Colors.green[100],
                    selectedColor: const Color(0xFF0A400C),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
