import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/models/user_model.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices _authRepository = AuthServices();
  final SellerServices sellerServices = SellerServices();
  final PractitionerServices practitionerServices = PractitionerServices();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthVerifyRegistrationOTPRequested>(
      _onAuthVerifyRegistrationOTPRequested,
    );
    on<AuthSendRegistrationOTPRequested>(_onAuthSendRegistrationOTPRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<CreateSellerProfileEvent>(_onCreateSellerProfile);
    on<CreatePractitionerProfileEvent>(_onCreatePractitionerProfile);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.getCurrentUser();

    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login gagal'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendRegistrationOTP(event.email, event.password);
      emit(AuthRegistrationOTPSent(event.email, event.password));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthVerifyRegistrationOTPRequested(
    AuthVerifyRegistrationOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.verifyRegistrationOTP(
        event.email,
        event.otp,
      );

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Verifikasi OTP gagal'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _onAuthSendRegistrationOTPRequested(
    AuthSendRegistrationOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.sendRegistrationOTP(event.email, event.password);
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login dengan Google gagal'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _onCreateSellerProfile(
    CreateSellerProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(CreateProfileLoading());
    try {
      final profile = await sellerServices.createProfile(
        event.data,
        event.userId,
      );

      // Assign role penjual (user sekarang punya 2 role)
      await _authRepository.assignRole('penjual', setActive: true);

      emit(SellerProfileSuccess(profile));
    } catch (e) {
      emit(CreateProfileError(e.toString()));
    }
  }

  Future<void> _onCreatePractitionerProfile(
    CreatePractitionerProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(CreateProfileLoading());
    try {
      final profile = await practitionerServices.createProfile(
        event.data,
        event.userId,
      );

      // Assign role praktisi (user sekarang punya 2 role)
      await _authRepository.assignRole('praktisi', setActive: true);
      emit(PractitionerProfileSuccess(profile));
    } catch (e) {
      emit(CreateProfileError(e.toString()));
    }
  }

  // void _onAuthCheckRequested(
  //   AuthCheckRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   final user = _authRepository.getCurrentUser();
  //   final UserRole role = await _roleRepository.getActiveRole();
  //   if (user != null) {
  //     emit(AuthAuthenticated(user, role));
  //   } else {
  //     emit(AuthUnauthenticated());
  //   }
  // }

  // Future<void> _onAuthLoginRequested(
  //   AuthLoginRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await _authRepository.signIn(event.email, event.password);
  //     final UserRole role = await _roleRepository.getActiveRole();
  //     if (user != null) {
  //       emit(AuthAuthenticated(user, role));
  //     } else {
  //       emit(AuthError('Login gagal'));
  //     }
  //   } on AuthException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (e) {
  //     emit(AuthError('Terjadi kesalahan: $e'));
  //   }
  // }

  // Future<void> _onAuthRegisterRequested(
  //   AuthRegisterRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     await _authRepository.sendRegistrationOTP(event.email, event.password);
  //     emit(AuthRegistrationOTPSent(event.email, event.password));
  //   } on AuthException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (e) {
  //     emit(AuthError('Terjadi kesalahan: $e'));
  //   }
  // }

  // Future<void> _onAuthLogoutRequested(
  //   AuthLogoutRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   await _authRepository.signOut();
  //   emit(AuthUnauthenticated());
  // }

  // Future<void> _onAuthVerifyRegistrationOTPRequested(
  //   AuthVerifyRegistrationOTPRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await _authRepository.verifyRegistrationOTP(
  //       event.email,
  //       event.otp,
  //     );
  //     final UserRole role = await _roleRepository.getActiveRole();
  //     if (user != null) {
  //       emit(AuthAuthenticated(user, role));
  //     } else {
  //       emit(AuthError('Verifikasi OTP gagal'));
  //     }
  //   } on AuthException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (e) {
  //     emit(AuthError('Terjadi kesalahan: $e'));
  //   }
  // }

  // Future<void> _onAuthSendRegistrationOTPRequested(
  //   AuthSendRegistrationOTPRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   try {
  //     await _authRepository.sendRegistrationOTP(event.email, event.password);
  //     // Tidak perlu emit state baru, tetap di halaman verifikasi
  //   } on AuthException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (e) {
  //     emit(AuthError('Terjadi kesalahan: $e'));
  //   }
  // }

  // Future<void> _onAuthGoogleSignInRequested(
  //   AuthGoogleSignInRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await _authRepository.signInWithGoogle();
  //     final UserRole role = await _roleRepository.getActiveRole();
  //     if (user != null) {
  //       emit(AuthAuthenticated(user, role));
  //     } else {
  //       emit(AuthError('Login dengan Google gagal'));
  //     }
  //   } on AuthException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (e) {
  //     emit(AuthError('Terjadi kesalahan: $e'));
  //   }
  // }
}
