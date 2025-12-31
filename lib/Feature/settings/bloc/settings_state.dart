// lib/Feature/settings/bloc/settings_state.dart
part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}

final class RoleSwitchSuccess extends SettingsState {
  final String roleName;

  RoleSwitchSuccess(this.roleName);
}

final class SellerProfileCreated extends SettingsState {
  final SellerProfile profile;

  SellerProfileCreated(this.profile);
}

final class PractitionerProfileCreated extends SettingsState {}
