part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthRegistrationSuccess extends AuthState {}

class AuthRegistrationOTPSent extends AuthState {
  final String email;
  final String password;

  AuthRegistrationOTPSent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}
