// lib/Feature/home/bloc/home_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/product_model.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/repositories/product_repository.dart';
import 'package:herbal_app/data/repositories/practitioner_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _productRepository;
  final PractitionerRepository _practitionerRepository;

  HomeBloc(this._productRepository, this._practitionerRepository)
    : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Jangan emit loading jika sudah ada data
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    try {
      // Load data secara parallel untuk performa lebih baik
      final results = await Future.wait([
        _productRepository.getNewestProducts(
          forceRefresh: event.forceRefresh ?? false,
        ),
        _practitionerRepository.getAllPractitioners(
          forceRefresh: event.forceRefresh ?? false,
        ),
      ]);

      final products = results[0] as List<Product>;
      final practitioners = results[1] as List<PractitionerProfile>;

      // Ekstrak kategori
      final Set<String> categoriesSet = {};
      for (var product in products) {
        if (product.kategori != null) {
          categoriesSet.addAll(product.kategori!);
        }
      }

      final List<String> categories = categoriesSet.toList()..sort();

      emit(
        HomeLoaded(
          products: products,
          practitioners: practitioners,
          categories: categories,
          selectedCategory: null,
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
    }
  }
}
