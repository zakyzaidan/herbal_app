part of 'praktisi_bloc.dart';

@immutable
sealed class PraktisiEvent {}

class LoadPractitionersEvent extends PraktisiEvent {
  final bool? forceRefresh;
  LoadPractitionersEvent({this.forceRefresh});
}

class SearchPractitionersEvent extends PraktisiEvent {
  final String query;

  SearchPractitionersEvent(this.query);
}
