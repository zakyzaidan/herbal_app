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

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _sellerServices.updateProduct(
        event.productId as int,
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
      await _sellerServices.deleteProduct(event.productId as int);
      emit(ProductDeletedSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
