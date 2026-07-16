import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

enum PlayerRole { civilian, undercover, misterWhite }

extension PlayerRoleLabel on PlayerRole {
  String get label => switch (this) {
    PlayerRole.civilian => 'Civil',
    PlayerRole.undercover => 'Undercover',
    PlayerRole.misterWhite => 'Mister White',
  };

  String get shortRule => switch (this) {
    PlayerRole.civilian => 'Tu connais le mot',
    PlayerRole.undercover => 'Ton mot est legerement different',
    PlayerRole.misterWhite => 'Tu dois deviner le mot',
  };
}

class WordTheme {
  const WordTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.pairs,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<WordPair> pairs;
}

class WordPair {
  const WordPair({
    required this.civilianWord,
    required this.undercoverWord,
    this.style = WordPairStyle.normal,
  });

  final String civilianWord;
  final String undercoverWord;
  final WordPairStyle style;
}

enum WordPairStyle { normal, softJoke, troll }

class PlayerAssignment {
  const PlayerAssignment({
    required this.id,
    required this.name,
    required this.role,
    required this.word,
    this.isEliminated = false,
  });

  final int id;
  final String name;
  final PlayerRole role;
  final String word;
  final bool isEliminated;

  PlayerAssignment copyWith({String? name, bool? isEliminated}) {
    return PlayerAssignment(
      id: id,
      name: name ?? this.name,
      role: role,
      word: word,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}

enum GameOutcomeType {
  inProgress,
  civiliansWin,
  specialRolesWin,
  misterWhiteGuessWin,
}

class GameOutcome {
  const GameOutcome({required this.type, this.winnerIds = const []});

  static const inProgress = GameOutcome(type: GameOutcomeType.inProgress);

  final GameOutcomeType type;
  final List<int> winnerIds;

  bool get isFinished => type != GameOutcomeType.inProgress;
}

class GameSession {
  const GameSession({
    required this.theme,
    required this.civilianWord,
    required this.undercoverWord,
    required this.assignments,
    required this.round,
    this.outcome = GameOutcome.inProgress,
  });

  final WordTheme theme;
  final String civilianWord;
  final String undercoverWord;
  final List<PlayerAssignment> assignments;
  final int round;
  final GameOutcome outcome;

  List<PlayerAssignment> get alivePlayers =>
      assignments.where((player) => !player.isEliminated).toList();

  GameSession copyWith({
    List<PlayerAssignment>? assignments,
    int? round,
    GameOutcome? outcome,
  }) {
    return GameSession(
      theme: theme,
      civilianWord: civilianWord,
      undercoverWord: undercoverWord,
      assignments: assignments ?? this.assignments,
      round: round ?? this.round,
      outcome: outcome ?? this.outcome,
    );
  }
}

class AppIcons {
  const AppIcons._();

  static const home = SolarIconsOutline.home;
  static const rules = SolarIconsOutline.book;
  static const newGame = SolarIconsOutline.addCircle;
  static const settings = SolarIconsOutline.settings;
  static const menu = SolarIconsOutline.menuDots;
  static const users = SolarIconsBold.usersGroupRounded;
  static const user = SolarIconsOutline.userRounded;
  static const undercover = SolarIconsBold.shieldKeyhole;
  static const misterWhite = SolarIconsBold.ghost;
  static const reveal = SolarIconsOutline.eye;
  static const play = SolarIconsOutline.play;
  static const edit = SolarIconsOutline.pen;
  static const vote = SolarIconsOutline.checklist;
  static const theme = SolarIconsOutline.gamepadMinimalistic;
  static const close = SolarIconsOutline.closeCircle;
  static const back = SolarIconsOutline.arrowLeft;
  static const bug = SolarIconsOutline.bug;
  static const idea = SolarIconsOutline.chatSquareLike;
  static const comment = SolarIconsOutline.chatRoundDots;
  static const upvote = SolarIconsBold.arrowUp;
  static const downvote = SolarIconsBold.arrowDown;
}
