part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadAllProductsEvent extends ProductEvent {}

class CreateProductEvent extends ProductEvent {
  final Product productInput;

  CreateProductEvent({required this.productInput});
}

class LoadProductsSellerEvent extends ProductEvent {
  final String umkmId;

  LoadProductsSellerEvent(this.umkmId);
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
