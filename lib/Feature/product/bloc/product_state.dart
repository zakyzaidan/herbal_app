part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductDeletedSuccess extends ProductState {}

class AllProductsLoaded extends ProductState {
  final List<ProductCartModel> products;
  final List<String> categories;

  AllProductsLoaded(this.products, this.categories);
}

class ProductCreatedSuccess extends ProductState {
  final Product product;

  ProductCreatedSuccess(this.product);
}

class ProductsSellerLoaded extends ProductState {
  final List<ProductCartModel> products;

  ProductsSellerLoaded(this.products);
}

class ProductDetailLoaded extends ProductState {
  final Product product;
  final SellerProfile seller;
  final bool isOwner;

  ProductDetailLoaded(this.product, this.seller, this.isOwner);
}

class ProductUpdatedSuccess extends ProductState {
  final Product product;

  ProductUpdatedSuccess(this.product);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
