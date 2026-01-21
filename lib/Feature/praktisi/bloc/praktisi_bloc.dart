// lib/Feature/praktisi/bloc/praktisi_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/repositories/practitioner_repository.dart';
import 'package:meta/meta.dart';

part 'praktisi_event.dart';
part 'praktisi_state.dart';

class PraktisiBloc extends Bloc<PraktisiEvent, PraktisiState> {
  final PractitionerRepository _repository;

  PraktisiBloc(this._repository) : super(PraktisiInitial()) {
    on<LoadPractitionersEvent>(_onLoadPractitioners);
    on<SearchPractitionersEvent>(_onSearchPractitioners);
  }

  Future<void> _onLoadPractitioners(
    LoadPractitionersEvent event,
    Emitter<PraktisiState> emit,
  ) async {
    if (state is! PraktisiLoaded) {
      emit(PraktisiLoading());
    }

    try {
      final practitioners = await _repository.getAllPractitioners(
        forceRefresh: event.forceRefresh ?? false,
      );
      emit(PraktisiLoaded(practitioners));
    } catch (e) {
      emit(PraktisiError(e.toString()));
    }
  }

  Future<void> _onSearchPractitioners(
    SearchPractitionersEvent event,
    Emitter<PraktisiState> emit,
  ) async {
    emit(PraktisiLoading());

    try {
      final practitioners = await _repository.searchPractitioners(
        query: event.query,
      );
      emit(PraktisiLoaded(practitioners));
    } catch (e) {
      emit(PraktisiError(e.toString()));
    }
  }
}
