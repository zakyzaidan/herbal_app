part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductDeletedSuccess extends ProductState {}

class ProductCreatedSuccess extends ProductState {
  final Product product;

  ProductCreatedSuccess(this.product);
}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class ProductUpdatedSuccess extends ProductState {
  final Product product;

  ProductUpdatedSuccess(this.product);
}

class ProductError extends ProductState {
  late final String message;

  ProductError(this.message);
}
