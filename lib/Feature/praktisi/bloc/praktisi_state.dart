// lib/Feature/praktisi/bloc/praktisi_state.dart
part of 'praktisi_bloc.dart';

@immutable
sealed class PraktisiState {}

final class PraktisiInitial extends PraktisiState {}

final class PraktisiLoading extends PraktisiState {}

final class PraktisiLoaded extends PraktisiState {
  final List<PractitionerProfile> practitioners;
  PraktisiLoaded(this.practitioners);
}

final class PraktisiError extends PraktisiState {
  final String message;
  PraktisiError(this.message);
}
