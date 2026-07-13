import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

enum PlayerRole { civilian, undercover, misterWhite }

extension PlayerRoleLabel on PlayerRole {
  String get label {
    return switch (this) {
      PlayerRole.civilian => 'Civil',
      PlayerRole.undercover => 'Undercover',
      PlayerRole.misterWhite => 'Mister White',
    };
  }

  String get shortRule {
    return switch (this) {
      PlayerRole.civilian => 'Tu connais le mot',
      PlayerRole.undercover => 'Ton mot est legerement different',
      PlayerRole.misterWhite => 'Tu dois deviner le mot',
    };
  }
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
  const WordPair({required this.civilianWord, required this.undercoverWord});

  final String civilianWord;
  final String undercoverWord;
}

class PlayerAssignment {
  const PlayerAssignment({
    required this.name,
    required this.role,
    required this.word,
    this.isEliminated = false,
  });

  final String name;
  final PlayerRole role;
  final String word;
  final bool isEliminated;

  PlayerAssignment copyWith({bool? isEliminated}) {
    return PlayerAssignment(
      name: name,
      role: role,
      word: word,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}

class GameSession {
  const GameSession({
    required this.theme,
    required this.assignments,
    required this.round,
  });

  final WordTheme theme;
  final List<PlayerAssignment> assignments;
  final int round;

  List<PlayerAssignment> get alivePlayers =>
      assignments.where((player) => !player.isEliminated).toList();
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
}
