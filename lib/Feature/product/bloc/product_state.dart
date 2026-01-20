part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductDeletedSuccess extends ProductState {}

class AllProductsLoaded extends ProductState {
  final List<Product> products;
  final List<String> categories;

  AllProductsLoaded(this.products, this.categories);
}

class ProductCreatedSuccess extends ProductState {
  final Product product;

  ProductCreatedSuccess(this.product);
}

class ProductsSellerLoaded extends ProductState {
  final List<Product> products;

  ProductsSellerLoaded(this.products);
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  ProductDetailLoaded(this.product);
}

class ProductUpdatedSuccess extends ProductState {
  final Product product;

  ProductUpdatedSuccess(this.product);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
