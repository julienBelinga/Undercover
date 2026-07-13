import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:undercover/models/game_models.dart';

class GameContentService {
  const GameContentService();

  List<WordTheme> themes() => const [
    WordTheme(
      id: 'general',
      name: 'General',
      description: 'Des mots simples pour lancer une partie rapide.',
      icon: SolarIconsOutline.gamepadMinimalistic,
      color: Color(0xFF36E879),
      pairs: [
        WordPair(civilianWord: 'Pizza', undercoverWord: 'Burger'),
        WordPair(civilianWord: 'Cinema', undercoverWord: 'Theatre'),
        WordPair(civilianWord: 'Plage', undercoverWord: 'Piscine'),
        WordPair(civilianWord: 'Train', undercoverWord: 'Metro'),
      ],
    ),
    WordTheme(
      id: 'manga',
      name: 'Manga',
      description: 'Ambiance anime, pouvoirs et rivaux.',
      icon: SolarIconsOutline.magicStick,
      color: Color(0xFFFF8A2A),
      pairs: [
        WordPair(civilianWord: 'Sensei', undercoverWord: 'Maitre'),
        WordPair(civilianWord: 'Tournoi', undercoverWord: 'Combat'),
        WordPair(civilianWord: 'Pouvoir', undercoverWord: 'Technique'),
        WordPair(civilianWord: 'Rival', undercoverWord: 'Ennemi'),
      ],
    ),
    WordTheme(
      id: 'cuisine',
      name: 'Cuisine',
      description: 'Ingredients, plats et ustensiles.',
      icon: SolarIconsOutline.chefHat,
      color: Color(0xFF8995FF),
      pairs: [
        WordPair(civilianWord: 'Four', undercoverWord: 'Micro-ondes'),
        WordPair(civilianWord: 'Pates', undercoverWord: 'Riz'),
        WordPair(civilianWord: 'Poivre', undercoverWord: 'Sel'),
        WordPair(civilianWord: 'Gateau', undercoverWord: 'Tarte'),
      ],
    ),
  ];

  WordTheme themeById(String id) {
    return themes().firstWhere(
      (theme) => theme.id == id,
      orElse: () => themes().first,
    );
  }
}
