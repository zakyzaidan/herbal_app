part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class CreateProductEvent extends ProductEvent {
  final Product productInput;

  CreateProductEvent({required this.productInput});
}

class LoadProductsEvent extends ProductEvent {
  final String umkmId;

  LoadProductsEvent(this.umkmId);
}

class UpdateProductEvent extends ProductEvent {
  final String productId;
  final Product product;

  UpdateProductEvent(this.productId, this.product);
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent(this.productId);
}
