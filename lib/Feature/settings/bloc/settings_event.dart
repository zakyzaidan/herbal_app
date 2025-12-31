// lib/Feature/settings/bloc/settings_event.dart
part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class SwitchRoleEvent extends SettingsEvent {
  final String roleName;

  SwitchRoleEvent(this.roleName);
}

class CreateSellerProfileEvent extends SettingsEvent {
  final Map<String, dynamic> data;
  final String userId;

  CreateSellerProfileEvent({required this.data, required this.userId});
}

class CreatePractitionerProfileEvent extends SettingsEvent {
  final Map<String, dynamic> data;
  final String userId;

  CreatePractitionerProfileEvent({required this.data, required this.userId});
}
