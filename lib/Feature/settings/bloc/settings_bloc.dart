// lib/Feature/settings/bloc/settings_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SellerServices _sellerServices = SellerServices();
  final PractitionerServices _praktisiServices = PractitionerServices();
  final AuthServices _authServices = AuthServices();

  SettingsBloc() : super(SettingsInitial()) {
    on<SwitchRoleEvent>(_onSwitchRole);
  }

  Future<void> _onSwitchRole(
    SwitchRoleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final success = await _authServices.switchRole(event.roleName);

      if (success) {
        emit(RoleSwitchSuccess(event.roleName));
      } else {
        emit(SettingsError('Gagal switch ke role ${event.roleName}'));
      }
    } catch (e) {
      emit(SettingsError('Terjadi kesalahan: $e'));
    }
  }
}
