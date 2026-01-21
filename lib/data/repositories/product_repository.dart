// lib/data/repositories/product_repository.dart

import 'dart:convert';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository {
  final SellerServices _sellerServices;
  final SharedPreferences _prefs;

  // Cache keys
  static const String _allProductsKey = 'cached_all_products';
  static const String _allProductsTimestampKey =
      'cached_all_products_timestamp';
  static const String _newestProductsKey = 'cached_newest_products';
  static const String _newestProductsTimestampKey =
      'cached_newest_products_timestamp';

  // Cache duration (5 minutes)
  static const Duration _cacheDuration = Duration(minutes: 5);

  ProductRepository(this._sellerServices, this._prefs);

  /// Get all products with caching
  Future<List<Product>> getAllProducts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedProducts = _getCachedProducts(
        _allProductsKey,
        _allProductsTimestampKey,
      );
      if (cachedProducts != null) {
        return cachedProducts;
      }
    }

    try {
      final products = await _sellerServices.getAllProducts();
      await _cacheProducts(products, _allProductsKey, _allProductsTimestampKey);
      return products;
    } catch (e) {
      // Jika gagal fetch, coba ambil cache lama walau expired
      final cachedProducts = _getCachedProducts(
        _allProductsKey,
        _allProductsTimestampKey,
        ignoreExpiry: true,
      );
      if (cachedProducts != null) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  /// Get newest products with caching
  Future<List<Product>> getNewestProducts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedProducts = _getCachedProducts(
        _newestProductsKey,
        _newestProductsTimestampKey,
      );
      if (cachedProducts != null) {
        return cachedProducts;
      }
    }

    try {
      final products = await _sellerServices.getNewestProducts();
      await _cacheProducts(
        products,
        _newestProductsKey,
        _newestProductsTimestampKey,
      );
      return products;
    } catch (e) {
      final cachedProducts = _getCachedProducts(
        _newestProductsKey,
        _newestProductsTimestampKey,
        ignoreExpiry: true,
      );
      if (cachedProducts != null) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  /// Get products by UMKM ID
  Future<List<Product>> getProductsByUmkmId(
    String umkmId, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'cached_products_umkm_$umkmId';
    final timestampKey = 'cached_products_umkm_${umkmId}_timestamp';

    if (!forceRefresh) {
      final cachedProducts = _getCachedProducts(cacheKey, timestampKey);
      if (cachedProducts != null) {
        return cachedProducts;
      }
    }

    try {
      final products = await _sellerServices.getProductsByUmkmId(umkmId);
      await _cacheProducts(products, cacheKey, timestampKey);
      return products;
    } catch (e) {
      final cachedProducts = _getCachedProducts(
        cacheKey,
        timestampKey,
        ignoreExpiry: true,
      );
      if (cachedProducts != null) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  /// Get product by ID
  Future<Product?> getProductById(int productId) async {
    return await _sellerServices.getProductById(productId);
  }

  /// Add product and clear relevant caches
  Future<Product> addProduct(Product product) async {
    final newProduct = await _sellerServices.addProduct(product);
    await _clearProductCaches();
    return newProduct;
  }

  /// Update product and clear relevant caches
  Future<Product> updateProduct(int id, Product product) async {
    final updatedProduct = await _sellerServices.updateProduct(id, product);
    await _clearProductCaches();
    return updatedProduct;
  }

  /// Delete product and clear relevant caches
  Future<void> deleteProduct(int id) async {
    await _sellerServices.deleteProduct(id);
    await _clearProductCaches();
  }

  // ========== Private Helper Methods ==========

  List<Product>? _getCachedProducts(
    String cacheKey,
    String timestampKey, {
    bool ignoreExpiry = false,
  }) {
    try {
      final cachedJson = _prefs.getString(cacheKey);
      final timestamp = _prefs.getInt(timestampKey);

      if (cachedJson == null || timestamp == null) return null;
      if (!ignoreExpiry) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheTime) > _cacheDuration) {
          return null;
        }
      }

      final List<dynamic> jsonList = json.decode(cachedJson);
      final products = jsonList.map((json) => Product.fromJson(json)).toList();
      return products;
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }

  Future<void> _cacheProducts(
    List<Product> products,
    String cacheKey,
    String timestampKey,
  ) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      await _prefs.setString(cacheKey, json.encode(jsonList));
      await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching products: $e');
    }
  }

  Future<void> _clearProductCaches() async {
    await _prefs.remove(_allProductsKey);
    await _prefs.remove(_allProductsTimestampKey);
    await _prefs.remove(_newestProductsKey);
    await _prefs.remove(_newestProductsTimestampKey);

    // Clear UMKM-specific caches
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cached_products_umkm_')) {
        await _prefs.remove(key);
      }
    }
  }

  /// Clear all caches (untuk logout atau force refresh)
  Future<void> clearAllCaches() async {
    await _clearProductCaches();
  }
}
