import 'package:undercover/config/supabase_config.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/user_profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayedWordPairService {
  PlayedWordPairService({this._client});

  SupabaseClient? _client;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _client ??= Supabase.instance.client;
  }

  Future<Set<String>> playedPairKeys(String themeId) async {
    final client = _supabase;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return {};

    final List<dynamic> rows;
    try {
      rows = await client
          .from('played_word_pairs')
          .select('civilian_word, undercover_word')
          .eq('user_id', user.id)
          .eq('theme_id', themeId);
    } catch (_) {
      return {};
    }

    return rows
        .map<String>(
          (row) => pairKey(
            WordPair(
              civilianWord: row['civilian_word'] as String,
              undercoverWord: row['undercover_word'] as String,
            ),
          ),
        )
        .toSet();
  }

  Future<void> markPlayed(WordTheme theme, WordPair pair) async {
    final client = _supabase;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;

    try {
      await client.from('played_word_pairs').upsert({
        'user_id': user.id,
        'theme_id': theme.id,
        'civilian_word': pair.civilianWord,
        'undercover_word': pair.undercoverWord,
      }, onConflict: 'user_id,theme_id,civilian_word,undercover_word');
      await UserProfileService(client: client).recordPlayedPair(theme, pair);
    } catch (_) {
      return;
    }
  }

  String pairKey(WordPair pair) =>
      '${pair.civilianWord.trim().toLowerCase()}::${pair.undercoverWord.trim().toLowerCase()}';
}
