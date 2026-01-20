import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:meta/meta.dart';

part 'praktisi_event.dart';
part 'praktisi_state.dart';

class PraktisiBloc extends Bloc<PraktisiEvent, PraktisiState> {
  PractitionerServices _practitionerServices = PractitionerServices();

  PraktisiBloc() : super(PraktisiInitial()) {
    on<LoadPractitionersEvent>(_onLoadPractitioners);
    on<SearchPractitionersEvent>(_onSearchPractitioners);
  }

  FutureOr<void> _onLoadPractitioners(
    LoadPractitionersEvent event,
    Emitter<PraktisiState> emit,
  ) async {
    emit(PraktisiLoading());
    List<PractitionerProfile> practitioners = await _practitionerServices
        .getAllPractitioners();
    emit(PraktisiLoaded(practitioners));
  }

  FutureOr<void> _onSearchPractitioners(
    SearchPractitionersEvent event,
    Emitter<PraktisiState> emit,
  ) {
    emit(PraktisiLoading());
    // Simulate searching practitioners
    Future.delayed(const Duration(seconds: 2), () {
      emit(PraktisiLoaded([]));
    });
  }
}
