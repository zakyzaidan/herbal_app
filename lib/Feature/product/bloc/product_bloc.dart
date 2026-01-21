// lib/Feature/product/bloc/product_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/repositories/product_repository.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<LoadProductsSellerEvent>(_onLoadSellerProducts);
    on<GetProductDetailEvent>(_onGetProductDetail);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Jangan emit loading jika sudah ada data (untuk menghindari flicker)
    if (state is! AllProductsLoaded) {
      emit(ProductLoading());
    }

    try {
      final products = await _repository.getAllProducts(
        forceRefresh: event.forceRefresh ?? false,
      );

      // Ekstrak kategori
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

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _repository.addProduct(event.productInput);
      emit(ProductCreatedSuccess(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadSellerProducts(
    LoadProductsSellerEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductsSellerLoaded) {
      emit(ProductLoading());
    }

    try {
      final products = await _repository.getProductsByUmkmId(
        event.umkmId,
        forceRefresh: event.forceRefresh ?? false,
      );
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
      final product = await _repository.getProductById(event.productId);
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
      final product = await _repository.updateProduct(
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
      await _repository.deleteProduct(int.parse(event.productId));
      emit(ProductDeletedSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
