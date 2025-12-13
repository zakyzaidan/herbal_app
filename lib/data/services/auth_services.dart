import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gotrue/src/types/auth_state.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart'
    hide AuthState;
import 'package:herbal_app/data/models/user_model.dart';
import 'package:herbal_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthServices {
  /// ---------------------------------------------------
  /// Helper: Build UserModel dari Supabase
  /// ---------------------------------------------------
  Future<UserModel> _buildUserModel(String userId) async {
    // ambil profile
    final profile = await supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();

    // ambil roles
    final roles = await supabase
        .from('user_roles')
        .select('role_id, is_active, roles(name)')
        .eq('user_id', userId);

    return UserModel.fromSupabase(
      userData: profile,
      rolesData: List<Map<String, dynamic>>.from(roles),
    );
  }

  /// ---------------------------------------------------
  /// SIGN IN, SIGN UP, SIGN OUT
  /// ---------------------------------------------------
  Future<UserModel?> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) return null;

    return await _buildUserModel(response.user!.id);
  }

  Future<UserModel?> signUp(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) return null;

    // Setelah signup, user biasanya belum punya profile/roles lengkap
    return await _buildUserModel(response.user!.id);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// ---------------------------------------------------
  /// CURRENT USER
  /// ---------------------------------------------------
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return await _buildUserModel(user.id);
  }

  /// ---------------------------------------------------
  /// AUTH STATE CHANGES (STREAM)
  /// ---------------------------------------------------
  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange.asyncMap(
      (data) async {
            final user = data.session?.user;

            if (user != null) {
              final userModel = await _buildUserModel(user.id);
              return AuthAuthenticated(userModel);
            }

            return AuthUnauthenticated();
          }
          as AuthState Function(AuthState event),
    );
  }

  /// ---------------------------------------------------
  /// OTP: SEND
  /// ---------------------------------------------------
  Future<void> sendRegistrationOTP(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  /// ---------------------------------------------------
  /// OTP: VERIFY
  /// ---------------------------------------------------
  Future<UserModel?> verifyRegistrationOTP(String email, String token) async {
    final response = await supabase.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: token,
    );

    if (response.user == null) return null;

    return await _buildUserModel(response.user!.id);
  }

  /// ---------------------------------------------------
  /// SIGN IN WITH GOOGLE
  /// ---------------------------------------------------
  Future<UserModel?> signInWithGoogle() async {
    String webClientId = dotenv.env["GCP_WEB_CLIENT_ID"]!;
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    unawaited(
      googleSignIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      ),
    );

    final googleAccount = await googleSignIn.authenticate();
    final googleAuth = googleAccount.authentication;

    if (googleAuth.idToken == null) {
      throw 'Google login gagal: idToken tidak ditemukan';
    }

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.idToken!,
    );

    if (response.user == null) return null;

    return await _buildUserModel(response.user!.id);
  }
}
