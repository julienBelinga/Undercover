import 'dart:math';

import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/game_setup_service.dart';

class GameFlowService {
  GameFlowService({Random? random}) : _random = random ?? Random();

  final Random _random;

  GameSession createSession({
    required GameSetupConfig config,
    required List<String> playerNames,
    required WordTheme theme,
  }) {
    final cleanNames = List.generate(config.totalPlayers, (index) {
      if (index < playerNames.length && playerNames[index].trim().isNotEmpty) {
        return playerNames[index].trim();
      }
      return 'Joueur ${index + 1}';
    });
    final pair = theme.pairs[_random.nextInt(theme.pairs.length)];
    final roles = <PlayerRole>[
      ...List.filled(config.civilians, PlayerRole.civilian),
      ...List.filled(config.undercovers, PlayerRole.undercover),
      ...List.filled(config.misterWhites, PlayerRole.misterWhite),
    ]..shuffle(_random);

    final assignments = <PlayerAssignment>[];
    for (var index = 0; index < cleanNames.length; index++) {
      final role = roles[index];
      assignments.add(
        PlayerAssignment(
          name: cleanNames[index],
          role: role,
          word: switch (role) {
            PlayerRole.civilian => pair.civilianWord,
            PlayerRole.undercover => pair.undercoverWord,
            PlayerRole.misterWhite => 'Aucun',
          },
        ),
      );
    }

    return GameSession(theme: theme, assignments: assignments, round: 1);
  }
}
