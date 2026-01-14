part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  AuthRegisterRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthVerifyRegistrationOTPRequested extends AuthEvent {
  final String email;
  final String otp;

  AuthVerifyRegistrationOTPRequested(this.email, this.otp);

  @override
  List<Object?> get props => [email, otp];
}

class AuthSendRegistrationOTPRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSendRegistrationOTPRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class CreateSellerProfileEvent extends AuthEvent {
  final Map<String, dynamic> data;
  final String userId;

  CreateSellerProfileEvent({required this.data, required this.userId});
}

class CreatePractitionerProfileEvent extends AuthEvent {
  final Map<String, dynamic> data;
  final String userId;

  CreatePractitionerProfileEvent({required this.data, required this.userId});
}
