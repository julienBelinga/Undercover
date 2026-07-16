// ignore_for_file: prefer_initializing_formals

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:undercover/models/game_models.dart';

class GameContentService {
  const GameContentService({AssetBundle? assetBundle})
    : _assetBundle = assetBundle;

  final AssetBundle? _assetBundle;

  AssetBundle get _bundle => _assetBundle ?? rootBundle;

  static const themeIds = [
    'general',
    'manga',
    'cuisine',
    'super_heros',
    'jeu_video',
    'sorcier_fantasy',
    'cinema',
    'personnalites_connues',
    'dessin_anime',
    'pop_culture',
  ];

  Future<List<WordTheme>> themes() async {
    final loadedThemes = <WordTheme>[];
    for (final id in themeIds) {
      final json = await _bundle.loadString('assets/themes/$id.json');
      loadedThemes.add(
        _themeFromJson(jsonDecode(json) as Map<String, dynamic>),
      );
    }
    return loadedThemes;
  }

  Future<WordTheme> themeById(String id) async {
    final loadedThemes = await themes();
    return loadedThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => loadedThemes.first,
    );
  }

  WordTheme _themeFromJson(Map<String, dynamic> json) {
    return WordTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: _iconFromName(json['icon'] as String?),
      color: _colorFromHex(json['color'] as String?),
      pairs: (json['pairs'] as List)
          .map((pair) => _pairFromJson(pair as Map<String, dynamic>))
          .toList(),
    );
  }

  WordPair _pairFromJson(Map<String, dynamic> json) {
    return WordPair(
      civilianWord: json['civilianWord'] as String,
      undercoverWord: json['undercoverWord'] as String,
      style: _styleFromName(json['style'] as String?),
    );
  }

  IconData _iconFromName(String? name) {
    return switch (name) {
      'cartoon' => SolarIconsOutline.stars,
      'chef' => SolarIconsOutline.chefHat,
      'film' => SolarIconsOutline.clapperboardPlay,
      'gamepad' => SolarIconsOutline.gamepadMinimalistic,
      'general' => SolarIconsOutline.gamepadMinimalistic,
      'magic' => SolarIconsOutline.magicStick,
      'shield' => SolarIconsBold.shieldKeyhole,
      'sparkle' => SolarIconsOutline.stars,
      'user' => SolarIconsOutline.userRounded,
      _ => AppIcons.theme,
    };
  }

  Color _colorFromHex(String? hex) {
    final value = hex?.replaceFirst('#', '');
    if (value == null || value.length != 6) {
      return const Color(0xFF36E879);
    }
    return Color(int.parse('FF$value', radix: 16));
  }

  WordPairStyle _styleFromName(String? name) {
    return switch (name) {
      'soft_joke' => WordPairStyle.softJoke,
      'troll' => WordPairStyle.troll,
      _ => WordPairStyle.normal,
    };
  }
}
