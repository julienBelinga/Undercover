import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/supabase_config.dart';
import 'package:undercover/services/user_profile_service.dart';

class AuthService {
  AuthService({this._client});

  SupabaseClient? _client;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _client ??= Supabase.instance.client;
  }

  bool get isConfigured => SupabaseConfig.isConfigured;

  User? get currentUser => _supabase?.auth.currentUser;

  bool get canUseNativeAppleSignIn =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Stream<AuthState> get authStateChanges =>
      _supabase?.auth.onAuthStateChange ?? const Stream.empty();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _requireClient();
    await client.auth.signInWithPassword(email: email, password: password);
    await UserProfileService(client: client).upsertCurrentUser();
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      throw const AuthException('Entre ton prenom pour creer ton compte.');
    }
    final client = _requireClient();
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name.trim()},
      emailRedirectTo: SupabaseConfig.redirectUrl,
    );
    await UserProfileService(client: client).upsertCurrentUser(name: name);
  }

  Future<void> signInWithGoogle() => _signInWithOAuth(OAuthProvider.google);

  Future<void> signInWithApple() async {
    final client = _requireClient();
    if (!canUseNativeAppleSignIn) {
      throw const AuthException(
        'Connexion Apple disponible uniquement sur iOS ou macOS.',
      );
    }

    final rawNonce = client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Token Apple introuvable.');
    }

    await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    await UserProfileService(client: client).upsertCurrentUser();
  }

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
