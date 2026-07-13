import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/supabase_config.dart';

class AuthService {
  AuthService({this._client});

  SupabaseClient? _client;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _client ??= Supabase.instance.client;
  }

  bool get isConfigured => SupabaseConfig.isConfigured;

  User? get currentUser => _supabase?.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _supabase?.auth.onAuthStateChange ?? const Stream.empty();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _requireClient();
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _requireClient();
    await client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: SupabaseConfig.redirectUrl,
    );
  }

  Future<void> signInWithGoogle() => _signInWithOAuth(OAuthProvider.google);

  Future<void> signInWithApple() => _signInWithOAuth(OAuthProvider.apple);

  Future<void> signOut() async {
    await _supabase?.auth.signOut();
  }

  Future<void> _signInWithOAuth(OAuthProvider provider) async {
    final client = _requireClient();
    await client.auth.signInWithOAuth(
      provider,
      redirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  }

  SupabaseClient _requireClient() {
    final client = _supabase;
    if (client == null) {
      throw const AuthException('Supabase n’est pas configure.');
    }
    return client;
  }
}
