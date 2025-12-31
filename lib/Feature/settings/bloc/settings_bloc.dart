// lib/Feature/settings/bloc/settings_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SellerServices _sellerServices = SellerServices();
  final AuthServices _authServices = AuthServices();

  SettingsBloc() : super(SettingsInitial()) {
    on<SwitchRoleEvent>(_onSwitchRole);
    on<CreateSellerProfileEvent>(_onCreateSellerProfile);
    on<CreatePractitionerProfileEvent>(_onCreatePractitionerProfile);
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

  Future<void> _onCreateSellerProfile(
    CreateSellerProfileEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      // Buat profil penjual
      final profile = await _sellerServices.createProfile(
        event.data,
        event.userId,
      );

      // Assign role penjual dan set sebagai aktif
      final success = await _authServices.assignRole(
        'penjual',
        setActive: true,
      );

      if (success) {
        emit(SellerProfileCreated(profile));
      } else {
        emit(SettingsError('Gagal mengaktifkan role penjual'));
      }
    } catch (e) {
      emit(SettingsError('Gagal membuat profil penjual: $e'));
    }
  }

  Future<void> _onCreatePractitionerProfile(
    CreatePractitionerProfileEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      // TODO: Implementasi service untuk praktisi
      // final profile = await _praktisiServices.createProfile(event.data, event.userId);

      // Assign role praktisi dan set sebagai aktif
      final success = await _authServices.assignRole(
        'praktisi',
        setActive: true,
      );

      if (success) {
        emit(PractitionerProfileCreated());
      } else {
        emit(SettingsError('Gagal mengaktifkan role praktisi'));
      }
    } catch (e) {
      emit(SettingsError('Gagal membuat profil praktisi: $e'));
    }
  }
}
