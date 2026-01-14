// lib/Feature/settings/bloc/settings_event.dart
part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class SwitchRoleEvent extends SettingsEvent {
  final String roleName;

  SwitchRoleEvent(this.roleName);
}
