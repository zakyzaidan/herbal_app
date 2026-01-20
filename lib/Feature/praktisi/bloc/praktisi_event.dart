part of 'praktisi_bloc.dart';

@immutable
sealed class PraktisiEvent {}

class LoadPractitionersEvent extends PraktisiEvent {}

class SearchPractitionersEvent extends PraktisiEvent {
  final String query;

  SearchPractitionersEvent(this.query);
}
