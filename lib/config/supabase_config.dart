import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static const _definedUrl = String.fromEnvironment('SUPABASE_URL');
  static const _definedPublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  static const _definedAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const redirectUrl = String.fromEnvironment(
    'SUPABASE_REDIRECT_URL',
    defaultValue: 'undercover://auth-callback',
  );

  static String get url => _definedUrl.isNotEmpty
      ? _definedUrl
      : _maybeEnv('NEXT_PUBLIC_SUPABASE_URL');

  static String get publishableKey {
    if (_definedPublishableKey.isNotEmpty) return _definedPublishableKey;
    if (_definedAnonKey.isNotEmpty) return _definedAnonKey;
    final nextPublicKey = _maybeEnv('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY');
    if (nextPublicKey.isNotEmpty) return nextPublicKey;
    return _maybeEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY');
  }

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  static String _maybeEnv(String key) {
    try {
      return dotenv.maybeGet(key) ?? '';
    } catch (_) {
      return '';
    }
  }
}
