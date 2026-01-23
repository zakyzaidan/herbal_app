// lib/Feature/home/bloc/home_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:herbal_app/data/models/product_cart_model.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SellerServices _sellerServices = GetIt.instance<SellerServices>();
  final PractitionerServices _practitionerServices =
      GetIt.instance<PractitionerServices>();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    try {
      final List<ProductCartModel> products = await _sellerServices
          .getAllProducts();
      final List<PractitionerProfile> practitioners =
          await _practitionerServices.getAllPractitioners();
      final List<String> categories = await _sellerServices.getAllCategories();

      emit(
        HomeLoaded(
          products: products,
          practitioners: practitioners,
          categories: categories,
          selectedCategory: '',
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
