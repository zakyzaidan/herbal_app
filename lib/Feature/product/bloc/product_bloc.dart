// lib/Feature/product/bloc/product_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/data/models/product_cart_model.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SellerServices _sellerServices = GetIt.instance<SellerServices>();

  ProductBloc() : super(ProductInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<LoadProductsSellerEvent>(_onLoadSellerProducts);
    on<LoadProductDetailEvent>(_onGetProductDetail);
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
      final List<ProductCartModel> products = await _sellerServices
          .getAllProducts();
      final categories = await _sellerServices.getAllCategories();

      emit(AllProductsLoaded(products, categories));
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
      final product = await _sellerServices.addProduct(event.product);

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
      final products = await _sellerServices.getProductsBySellerId(
        event.umkmId,
      );

      emit(ProductsSellerLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onGetProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _sellerServices.getProductById(event.productId);
      final seller = await _sellerServices.getSellerByProductId(
        event.productId,
      );
      final bool isOwner = await _sellerServices.isOwnerBySellerId(
        event.authState,
        product!.umkmId,
      );

      emit(ProductDetailLoaded(product, seller!, isOwner));
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
        event.productId,
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
      await _sellerServices.deleteProduct(event.productId);
      emit(ProductDeletedSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
