part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class SelectCategoryEvent extends HomeEvent {
  final String category;

  SelectCategoryEvent(this.category);
}
