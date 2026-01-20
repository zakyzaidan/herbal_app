import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SellerServices _sellerServices = SellerServices();
  final PractitionerServices _practitionerServices = PractitionerServices();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // Load produk terbaru (15 produk)
      final products = await _sellerServices.getNewestProducts();

      // Load semua praktisi
      final practitioners = await _practitionerServices.getAllPractitioners();

      // Ekstrak dan gabungkan semua kategori dari produk
      final Set<String> categoriesSet = {};
      for (var product in products) {
        if (product.kategori != null) {
          categoriesSet.addAll(product.kategori!);
        }
      }

      // Convert ke list dan sort
      final List<String> categories = categoriesSet.toList()..sort();

      emit(
        HomeLoaded(
          products: products,
          practitioners: practitioners,
          categories: categories,
          selectedCategory: null, // Tidak ada kategori yang dipilih
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Jika kategori yang sama diklik lagi, batalkan seleksi
      final newSelectedCategory =
          currentState.selectedCategory == event.category
          ? null
          : event.category;

      emit(
        HomeLoaded(
          products: currentState.products,
          practitioners: currentState.practitioners,
          categories: currentState.categories,
          selectedCategory: newSelectedCategory,
        ),
      );

      // TODO: Coming soon - Filter produk berdasarkan kategori
      // Nanti akan navigate ke halaman product dengan filter kategori
      if (newSelectedCategory != null) {
        print('Category selected: $newSelectedCategory');
        // Navigator.push(...) ke halaman product dengan filter
      }
    }
  }
}
