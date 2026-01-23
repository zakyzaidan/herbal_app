import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';
import 'package:herbal_app/components/category_section.dart';
import 'package:herbal_app/components/produk_cart.dart';
import 'package:herbal_app/components/search_bar_widget.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: searchBar(() {}, "Cari produk herbal..."),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AllProductsLoaded) {
                  final products = state.products;
                  final categories = state.categories;
                  final selectedCategory = state.selectedCategory;
                  return Column(
                    children: [
                      CategorySection(
                        categories: categories,
                        selectedCategory: selectedCategory,
                      ),
                      Expanded(
                        child: MasonryGridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProdukCart(product: product);
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
