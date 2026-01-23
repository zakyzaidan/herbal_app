part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadAllProductsEvent extends ProductEvent {
  final bool? forceRefresh;
  final String selectedCategory;

  LoadAllProductsEvent({this.forceRefresh, this.selectedCategory = ''});
}

class LoadProductDetailEvent extends ProductEvent {
  final int productId;
  final AuthState authState;

  LoadProductDetailEvent(this.productId, this.authState);
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  CreateProductEvent({required this.product});
}

class LoadProductsSellerEvent extends ProductEvent {
  final String umkmId;
  final bool? forceRefresh;

  LoadProductsSellerEvent(this.umkmId, {this.forceRefresh});
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final Product product;

  UpdateProductEvent(this.productId, this.product);
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  DeleteProductEvent(this.productId);
}
