class GameSetupConfig {
  const GameSetupConfig({
    required this.totalPlayers,
    required this.civilians,
    required this.undercovers,
    required this.misterWhites,
  });

  final int totalPlayers;
  final int civilians;
  final int undercovers;
  final int misterWhites;

  int get assignedPlayers => civilians + undercovers + misterWhites;

  bool get isValid =>
      totalPlayers >= GameSetupService.minPlayers &&
      totalPlayers <= GameSetupService.maxPlayers &&
      civilians >= 1 &&
      undercovers >= 1 &&
      misterWhites >= 0 &&
      assignedPlayers == totalPlayers;

  String? get validationMessage {
    if (civilians < 1) {
      return 'Il faut au moins 1 civil.';
    }
    if (undercovers < 1) {
      return 'Il faut au moins 1 undercover.';
    }
    if (assignedPlayers != totalPlayers) {
      return 'La repartition doit correspondre au nombre de joueurs.';
    }
    return null;
  }
}

class GameSetupService {
  const GameSetupService();

  static const int minPlayers = 3;
  static const int maxPlayers = 20;
  static const int defaultPlayers = 6;

  GameSetupConfig initialConfig() => configForPlayerCount(defaultPlayers);

  GameSetupConfig configForPlayerCount(int totalPlayers) {
    final clampedTotal = totalPlayers.clamp(minPlayers, maxPlayers);
    final undercovers = clampedTotal >= 10 ? 2 : 1;
    final misterWhites = clampedTotal >= 6 ? 1 : 0;

    return _compose(
      totalPlayers: clampedTotal,
      undercovers: undercovers,
      misterWhites: misterWhites,
    );
  }

  GameSetupConfig incrementUndercover(GameSetupConfig config) {
    if (!canIncrementUndercover(config)) {
      return config;
    }

    return _compose(
      totalPlayers: config.totalPlayers,
      undercovers: config.undercovers + 1,
      misterWhites: config.misterWhites,
    );
  }

  GameSetupConfig decrementUndercover(GameSetupConfig config) {
    if (!canDecrementUndercover(config)) {
      return config;
    }

    return _compose(
      totalPlayers: config.totalPlayers,
      undercovers: config.undercovers - 1,
      misterWhites: config.misterWhites,
    );
  }

  GameSetupConfig incrementMisterWhite(GameSetupConfig config) {
    if (!canIncrementMisterWhite(config)) {
      return config;
    }

    return _compose(
      totalPlayers: config.totalPlayers,
      undercovers: config.undercovers,
      misterWhites: config.misterWhites + 1,
    );
  }

  GameSetupConfig decrementMisterWhite(GameSetupConfig config) {
    if (!canDecrementMisterWhite(config)) {
      return config;
    }

    return _compose(
      totalPlayers: config.totalPlayers,
      undercovers: config.undercovers,
      misterWhites: config.misterWhites - 1,
    );
  }

  bool canIncrementUndercover(GameSetupConfig config) =>
      config.undercovers + config.misterWhites < config.totalPlayers - 1;

  bool canDecrementUndercover(GameSetupConfig config) => config.undercovers > 1;

  bool canIncrementMisterWhite(GameSetupConfig config) =>
      config.undercovers + config.misterWhites < config.totalPlayers - 1;

  bool canDecrementMisterWhite(GameSetupConfig config) =>
      config.misterWhites > 0;

  GameSetupConfig _compose({
    required int totalPlayers,
    required int undercovers,
    required int misterWhites,
  }) {
    final civilians = totalPlayers - undercovers - misterWhites;

    return GameSetupConfig(
      totalPlayers: totalPlayers,
      civilians: civilians,
      undercovers: undercovers,
      misterWhites: misterWhites,
    );
  }
}
