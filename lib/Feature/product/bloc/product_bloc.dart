// product_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SellerServices _sellerServices = SellerServices();

  ProductBloc() : super(ProductInitial()) {
    on<CreateProductEvent>(_onCreateProduct);
    on<LoadProductsEvent>(_onLoadProducts);
    on<GetProductDetailEvent>(_onGetProductDetail);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _sellerServices.addProduct(event.productInput);
      emit(ProductCreatedSuccess(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _sellerServices.getProductsByUmkmId(event.umkmId);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onGetProductDetail(
    GetProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _sellerServices.getProductById(event.productId);
      if (product != null) {
        emit(ProductDetailLoaded(product));
      } else {
        emit(ProductError('Produk tidak ditemukan'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _sellerServices.updateProduct(
        int.parse(event.productId),
        event.product,
      );
      emit(ProductUpdatedSuccess(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _sellerServices.deleteProduct(int.parse(event.productId));
      emit(ProductDeletedSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
