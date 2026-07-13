import 'dart:math';

import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/services/played_word_pair_service.dart';

class GameFlowService {
  GameFlowService({Random? random, PlayedWordPairService? playedPairs})
    : _random = random ?? Random(),
      _playedPairs = playedPairs ?? PlayedWordPairService();

  final Random _random;
  final PlayedWordPairService _playedPairs;

  Future<GameSession> prepareSessionAvoidingPlayedPairs({
    required GameSetupConfig config,
    required WordTheme theme,
  }) async {
    final playedKeys = await _playedPairs.playedPairKeys(theme.id);
    final availablePairs = theme.pairs
        .where((pair) => !playedKeys.contains(_playedPairs.pairKey(pair)))
        .toList();
    final session = prepareSession(
      config: config,
      theme: theme,
      pairPool: availablePairs.isEmpty ? null : availablePairs,
    );
    await _playedPairs.markPlayed(
      theme,
      WordPair(
        civilianWord: session.civilianWord,
        undercoverWord: session.undercoverWord,
      ),
    );
    return session;
  }

  GameSession prepareSession({
    required GameSetupConfig config,
    required WordTheme theme,
    List<WordPair>? pairPool,
  }) {
    final pairs = pairPool ?? theme.pairs;
    final pair = pairs[_random.nextInt(pairs.length)];
    final roles = <PlayerRole>[
      ...List.filled(config.civilians, PlayerRole.civilian),
      ...List.filled(config.undercovers, PlayerRole.undercover),
      ...List.filled(config.misterWhites, PlayerRole.misterWhite),
    ]..shuffle(_random);

    final assignments = List.generate(config.totalPlayers, (index) {
      final role = roles[index];
      return PlayerAssignment(
        id: index,
        name: '',
        role: role,
        word: switch (role) {
          PlayerRole.civilian => pair.civilianWord,
          PlayerRole.undercover => pair.undercoverWord,
          PlayerRole.misterWhite => 'Aucun mot',
        },
      );
    });

    return GameSession(
      theme: theme,
      civilianWord: pair.civilianWord,
      undercoverWord: pair.undercoverWord,
      assignments: assignments,
      round: 1,
    );
  }

  Future<GameSession> prepareReplaySession({
    required GameSession previousSession,
    WordTheme? theme,
    String? additionalPlayerName,
  }) async {
    final names = [
      ...previousSession.assignments.map((player) => player.name),
      if (additionalPlayerName != null) additionalPlayerName.trim(),
    ];
    final previousUndercovers = previousSession.assignments
        .where((player) => player.role == PlayerRole.undercover)
        .length;
    final previousMisterWhites = previousSession.assignments
        .where((player) => player.role == PlayerRole.misterWhite)
        .length;
    final config = GameSetupConfig(
      totalPlayers: names.length,
      civilians: names.length - previousUndercovers - previousMisterWhites,
      undercovers: previousUndercovers,
      misterWhites: previousMisterWhites,
    );
    var session = await prepareSessionAvoidingPlayedPairs(
      config: config,
      theme: theme ?? previousSession.theme,
    );
    for (var index = 0; index < names.length; index++) {
      session = assignPlayerName(session, index, names[index]);
    }
    return session;
  }

  String? validatePlayerName(GameSession session, int playerId, String name) {
    final normalized = normalize(name);
    if (normalized.isEmpty) {
      return 'Entre un prenom pour continuer.';
    }
    final duplicate = session.assignments.any(
      (player) => player.id != playerId && normalize(player.name) == normalized,
    );
    return duplicate ? 'Ce prenom est deja utilise.' : null;
  }

  GameSession assignPlayerName(GameSession session, int playerId, String name) {
    if (validatePlayerName(session, playerId, name) != null) {
      return session;
    }
    return session.copyWith(
      assignments: session.assignments
          .map(
            (player) => player.id == playerId
                ? player.copyWith(name: name.trim())
                : player,
          )
          .toList(),
    );
  }

  GameSession eliminatePlayer(GameSession session, int playerId) {
    if (!session.alivePlayers.any((player) => player.id == playerId)) {
      return session;
    }
    return session.copyWith(
      assignments: session.assignments
          .map(
            (player) => player.id == playerId
                ? player.copyWith(isEliminated: true)
                : player,
          )
          .toList(),
      round: session.round + 1,
    );
  }

  GameOutcome checkOutcome(GameSession session) {
    final alive = session.alivePlayers;
    final civilians = alive
        .where((player) => player.role == PlayerRole.civilian)
        .toList();
    final specials = alive
        .where((player) => player.role != PlayerRole.civilian)
        .toList();

    if (specials.isEmpty) {
      return GameOutcome(
        type: GameOutcomeType.civiliansWin,
        winnerIds: civilians.map((player) => player.id).toList(),
      );
    }
    if (civilians.length <= specials.length) {
      return GameOutcome(
        type: GameOutcomeType.specialRolesWin,
        winnerIds: specials.map((player) => player.id).toList(),
      );
    }
    return GameOutcome.inProgress;
  }

  GameOutcome checkMisterWhiteGuess(
    GameSession session,
    int playerId,
    String guess,
  ) {
    final player = session.assignments.firstWhere(
      (candidate) => candidate.id == playerId,
    );
    if (player.role == PlayerRole.misterWhite &&
        normalize(guess) == normalize(session.civilianWord)) {
      return GameOutcome(
        type: GameOutcomeType.misterWhiteGuessWin,
        winnerIds: [playerId],
      );
    }
    return checkOutcome(session);
  }

  GameSession applyOutcome(GameSession session, GameOutcome outcome) =>
      session.copyWith(outcome: outcome);

  String normalize(String value) {
    const accented = 'àáâäãåçèéêëìíîïñòóôöõùúûüýÿ';
    const plain = 'aaaaaaceeeeiiiinooooouuuuyy';
    var result = value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    for (var index = 0; index < accented.length; index++) {
      result = result.replaceAll(accented[index], plain[index]);
    }
    return result;
  }
}
