part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ProductCartModel> products;
  final List<PractitionerProfile> practitioners;
  final List<String> categories; // List kategori dari semua produk
  final String? selectedCategory; // Kategori yang sedang dipilih (nullable)

  HomeLoaded({
    required this.products,
    required this.practitioners,
    required this.categories,
    this.selectedCategory,
  });
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
