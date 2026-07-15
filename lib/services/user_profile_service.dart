import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/supabase_config.dart';
import 'package:undercover/models/game_models.dart';

class UserProfileService {
  UserProfileService({SupabaseClient? client}) : _supabaseClient = client;

  SupabaseClient? _supabaseClient;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _supabaseClient ??= Supabase.instance.client;
  }

  Future<void> upsertCurrentUser({String? name}) async {
    final client = _supabase;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;

    final cleanedName = name?.trim();
    try {
      await client.from('users').upsert({
        'auth_user_id': user.id,
        'name': cleanedName?.isNotEmpty == true
            ? cleanedName
            : _displayNameFor(user),
        'mail': user.email ?? '',
      }, onConflict: 'auth_user_id');
    } catch (_) {
      return;
    }
  }

  Future<void> saveTheme(String themeId) async {
    final client = _supabase;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;

    try {
      await upsertCurrentUser();
      await client
          .from('users')
          .update({'theme': themeId})
          .eq('auth_user_id', user.id);
    } catch (_) {
      return;
    }
  }

  Future<void> recordPlayedPair(WordTheme theme, WordPair pair) async {
    final client = _supabase;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;

    try {
      await upsertCurrentUser();
      final row = await client
          .from('users')
          .select('played_pairs')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      final playedPairs = List<Map<String, dynamic>>.from(
        ((row?['played_pairs'] as List?) ?? const []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );
      final entry = {
        'theme_id': theme.id,
        'civilian_word': pair.civilianWord,
        'undercover_word': pair.undercoverWord,
      };
      final alreadyRecorded = playedPairs.any(
        (played) =>
            played['theme_id'] == entry['theme_id'] &&
            played['civilian_word'] == entry['civilian_word'] &&
            played['undercover_word'] == entry['undercover_word'],
      );
      if (!alreadyRecorded) {
        playedPairs.add(entry);
        await client
            .from('users')
            .update({'played_pairs': playedPairs})
            .eq('auth_user_id', user.id);
      }
    } catch (_) {
      return;
    }
  }

  String _displayNameFor(User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final metadataName =
        metadata['name'] ?? metadata['full_name'] ?? metadata['user_name'];
    if (metadataName is String && metadataName.trim().isNotEmpty) {
      return metadataName.trim();
    }
    final email = user.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return '';
  }
}
