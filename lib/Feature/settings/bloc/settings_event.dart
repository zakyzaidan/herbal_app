part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class CreateSellerProfileEvent extends SettingsEvent {
  final Map<String, dynamic> data;
  final String userId;

  CreateSellerProfileEvent({required this.data, required this.userId});
}

class ResetSellerProfileEvent extends SettingsEvent {}