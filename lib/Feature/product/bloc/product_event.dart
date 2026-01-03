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

class GetProductDetailEvent extends ProductEvent {
  final int productId;

  GetProductDetailEvent(this.productId);
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
