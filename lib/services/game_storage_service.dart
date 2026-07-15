import 'package:shared_preferences/shared_preferences.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/services/user_profile_service.dart';

class GameStorageService {
  const GameStorageService();

  static const _playerNamesKey = 'player_names';
  static const _themeIdKey = 'theme_id';
  static const _totalPlayersKey = 'total_players';
  static const _undercoversKey = 'undercovers';
  static const _misterWhitesKey = 'mister_whites';

  Future<List<String>> loadPlayerNames(int totalPlayers) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList(_playerNamesKey) ?? const [];

    return List.generate(totalPlayers, (index) {
      if (index < savedNames.length && savedNames[index].trim().isNotEmpty) {
        return savedNames[index];
      }
      return 'Joueur ${index + 1}';
    });
  }

  Future<void> savePlayerNames(List<String> names) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_playerNamesKey, names);
  }

  Future<String?> loadThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeIdKey);
  }

  Future<void> saveThemeId(String themeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeIdKey, themeId);
    await UserProfileService().saveTheme(themeId);
  }

  Future<GameSetupConfig?> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final totalPlayers = prefs.getInt(_totalPlayersKey);
    final undercovers = prefs.getInt(_undercoversKey);
    final misterWhites = prefs.getInt(_misterWhitesKey);

    if (totalPlayers == null || undercovers == null || misterWhites == null) {
      return null;
    }

    final civilians = totalPlayers - undercovers - misterWhites;
    final config = GameSetupConfig(
      totalPlayers: totalPlayers,
      civilians: civilians,
      undercovers: undercovers,
      misterWhites: misterWhites,
    );

    return config.isValid ? config : null;
  }

  Future<void> saveConfig(GameSetupConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalPlayersKey, config.totalPlayers);
    await prefs.setInt(_undercoversKey, config.undercovers);
    await prefs.setInt(_misterWhitesKey, config.misterWhites);
  }
}
