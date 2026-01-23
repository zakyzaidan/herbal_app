import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';

class CategorySection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final int jumlahBaris;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    this.jumlahBaris = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Tambahkan "Semua Produk" di awal
    List<String> allCategories = ['Semua Produk', ...categories];

    // Jika kosong selain "Semua Produk"
    if (allCategories.length == 1) {
      return _emptyState();
    }

    // Default aktif = Semua Produk
    String activeCategory = selectedCategory == '' ? 'Semua Produk' : '';

    if (categories.contains(selectedCategory)) {
      activeCategory = selectedCategory;
      allCategories.remove(selectedCategory);
      allCategories = [selectedCategory, ...allCategories];
    }

    // Hitung item per baris
    final int itemsPerRow = (allCategories.length / jumlahBaris).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate baris dinamis
        for (int row = 0; row < jumlahBaris; row++)
          _buildCategoryRow(
            context,
            allCategories.skip(row * itemsPerRow).take(itemsPerRow).toList(),
            activeCategory,
          ),
      ],
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    List<String> rowCategories,
    String activeCategory,
  ) {
    if (rowCategories.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: rowCategories.map((category) {
            final bool isSelected = category == activeCategory;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  context.read<ProductBloc>().add(
                    LoadAllProductsEvent(selectedCategory: category),
                  );
                  context.go("/products");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0A400C)
                        : Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // FilterChip(
              //   label: Text(category),
              //   selected: isSelected,
              //   onSelected: (_) {
              //     // context.read<HomeBloc>().add(
              //     //       SelectCategoryEvent(
              //     //         category == 'Semua Produk' ? null : category,
              //     //       ),
              //     //     );
              //   },
              //   backgroundColor: isSelected
              //       ? const Color(0xFF0A400C)
              //       : Colors.green[100],
              //   selectedColor: const Color(0xFF0A400C),
              //   labelStyle: TextStyle(
              //     color: isSelected ? Colors.white : Colors.green[900],
              //     fontWeight: FontWeight.w500,
              //   ),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 8,
              //   ),
              // ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Belum ada kategori produk',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
