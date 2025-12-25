part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

class SellerProfileInitial extends SettingsState {}

class SellerProfileLoading extends SettingsState {}

class SellerProfileSuccess extends SettingsState {
  final SellerProfile profile;

  SellerProfileSuccess(this.profile);
}

class SellerProfileError extends SettingsState {
  final String message;

  SellerProfileError(this.message);
}