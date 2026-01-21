part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {
  final bool? forceRefresh;

  LoadHomeDataEvent({this.forceRefresh});
}

class SelectCategoryEvent extends HomeEvent {
  final String category;

  SelectCategoryEvent(this.category);
}
