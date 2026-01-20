// product_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SellerServices _sellerServices = SellerServices();

  ProductBloc() : super(ProductInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<LoadProductsSellerEvent>(_onLoadSellerProducts);
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

  Future<void> _onLoadSellerProducts(
    LoadProductsSellerEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _sellerServices.getProductsByUmkmId(event.umkmId);
      emit(ProductsSellerLoaded(products));
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

  FutureOr<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _sellerServices.getAllProducts();
      // Ekstrak dan gabungkan semua kategori dari produk
      final Set<String> categoriesSet = {};
      for (var product in products) {
        if (product.kategori != null) {
          categoriesSet.addAll(product.kategori!);
        }
      }
      emit(AllProductsLoaded(products, categoriesSet.toList()));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
