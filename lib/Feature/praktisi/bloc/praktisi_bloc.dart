// lib/Feature/praktisi/bloc/praktisi_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:meta/meta.dart';

part 'praktisi_event.dart';
part 'praktisi_state.dart';

class PraktisiBloc extends Bloc<PraktisiEvent, PraktisiState> {
  final PractitionerServices _practitionerServices =
      GetIt.instance<PractitionerServices>();

  PraktisiBloc() : super(PraktisiInitial()) {
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
      final practitioners = await _practitionerServices.getAllPractitioners();
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
      final practitioners = await _practitionerServices.searchPractitioners(
        event.query,
      );
      emit(PraktisiLoaded(practitioners));
    } catch (e) {
      emit(PraktisiError(e.toString()));
    }
  }
}
