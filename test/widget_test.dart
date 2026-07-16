import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undercover/main.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/distribution_page.dart';
import 'package:undercover/pages/game_setup_page.dart';
import 'package:undercover/pages/result_page.dart';
import 'package:undercover/pages/theme_selection_page.dart';
import 'package:undercover/services/game_content_service.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_setup_service.dart';

class _FileAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  final testTheme = WordTheme(
    id: 'test',
    name: 'Test',
    description: 'Theme de test',
    icon: AppIcons.theme,
    color: Colors.green,
    pairs: List.generate(
      20,
      (index) => WordPair(
        civilianWord: 'Civil $index',
        undercoverWord: 'Secret $index',
      ),
    ),
  );

  Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
    for (var index = 0; index < 20; index++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 500));
        return;
      }
    }
    expect(finder, findsOneWidget);
  }

  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        child: MyApp(key: UniqueKey()),
      ),
    );
    await pumpUntilFound(tester, find.byType(ThemeSelectionPage));
  }

  testWidgets('app starts on theme selection and opens setup', (tester) async {
    await pumpApp(tester);

    expect(find.byType(ThemeSelectionPage), findsOneWidget);
    await pumpUntilFound(tester, find.byKey(const Key('theme-general')));
    await tester.tap(find.byKey(const Key('theme-general')));
    await pumpUntilFound(tester, find.byType(GameSetupPage));

    expect(find.byType(GameSetupPage), findsOneWidget);
    expect(find.textContaining('General - Repartition'), findsOneWidget);
  });

  testWidgets('setup starts sequential player distribution', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: GameSetupPage(theme: testTheme),
      ),
    );
    await pumpUntilFound(tester, find.text('Commencer la partie'));
    await tester.tap(find.text('Commencer la partie'));
    await pumpUntilFound(tester, find.byType(DistributionPage));

    expect(find.byType(DistributionPage), findsOneWidget);
    expect(find.byKey(const Key('player-name-1')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('player-name-1')), 'Julien');
    await tester.tap(find.text('Valider le prenom'));
    await tester.pump();
    expect(find.textContaining('Julien'), findsOneWidget);

    await tester.tap(find.text('Reveler ma carte'));
    await tester.pump();
    expect(find.byKey(const Key('secret-word')), findsOneWidget);

    await tester.tap(find.text('Joueur suivant'));
    await tester.pump();
    expect(find.byKey(const Key('player-name-2')), findsOneWidget);
  });

  testWidgets('distribution rejects empty and duplicate names', (tester) async {
    final session = GameFlowService(random: Random(1)).prepareSession(
      config: const GameSetupService().configForPlayerCount(3),
      theme: testTheme,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: DistributionPage(session: session),
      ),
    );

    await tester.tap(find.text('Valider le prenom'));
    await tester.pump();
    expect(find.text('Entre un prenom pour continuer.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('player-name-1')), 'Élodie');
    await tester.tap(find.text('Valider le prenom'));
    await tester.pump();
    await tester.tap(find.text('Reveler ma carte'));
    await tester.pump();
    await tester.tap(find.text('Joueur suivant'));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('player-name-2')), ' elodie ');
    await tester.tap(find.text('Valider le prenom'));
    await tester.pump();
    expect(find.text('Ce prenom est deja utilise.'), findsOneWidget);
  });

  testWidgets('adding a player closes dialog without controller error', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final flow = GameFlowService(random: Random(2));
    var session = flow.prepareSession(
      config: const GameSetupService().configForPlayerCount(3),
      theme: testTheme,
    );
    for (var index = 0; index < session.assignments.length; index++) {
      session = flow.assignPlayerName(session, index, 'Player $index');
    }
    session = flow.applyOutcome(
      session,
      GameOutcome(
        type: GameOutcomeType.civiliansWin,
        winnerIds: session.assignments
            .where((player) => player.role == PlayerRole.civilian)
            .map((player) => player.id)
            .toList(),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: ResultPage(session: session),
      ),
    );

    await tester.tap(find.text('Ajouter un joueur'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('additional-player-name')),
      'Player 4',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(DistributionPage), findsOneWidget);
  });

  group('GameContentService', () {
    final contentService = GameContentService(assetBundle: _FileAssetBundle());

    test('loads expected JSON themes with 300 valid pairs each', () async {
      final themes = await contentService.themes();
      expect(themes.map((theme) => theme.id), GameContentService.themeIds);

      for (final theme in themes) {
        expect(File('assets/themes/${theme.id}.json').existsSync(), isTrue);
        expect(theme.pairs.length, 300);
        for (final pair in theme.pairs) {
          expect(pair.civilianWord.trim(), isNotEmpty);
          expect(pair.undercoverWord.trim(), isNotEmpty);
        }
      }
    });

    test('keeps pairs unique and joke ratio below limits', () async {
      final themes = await contentService.themes();
      final broadThemeIds = {
        'general',
        'cuisine',
        'cinema',
        'personnalites_connues',
      };
      var totalPairs = 0;
      var jokePairs = 0;

      for (final theme in themes) {
        final seen = <String>{};
        var broadThemeJokes = 0;
        for (final pair in theme.pairs) {
          final key =
              '${pair.civilianWord.trim().toLowerCase()}::'
              '${pair.undercoverWord.trim().toLowerCase()}';
          expect(seen.add(key), isTrue);
          totalPairs++;
          if (pair.style != WordPairStyle.normal) {
            jokePairs++;
            broadThemeJokes++;
          }
        }
        if (broadThemeIds.contains(theme.id)) {
          expect(broadThemeJokes / theme.pairs.length, lessThan(0.05));
        }
      }

      expect(jokePairs / totalPairs, lessThan(0.2));
    });
  });

  group('GameFlowService', () {
    const setup = GameSetupService();

    GameSession namedSession(GameSetupConfig config) {
      final flow = GameFlowService(random: Random(3));
      var session = flow.prepareSession(config: config, theme: testTheme);
      for (var index = 0; index < session.assignments.length; index++) {
        session = flow.assignPlayerName(session, index, 'Player $index');
      }
      return session;
    }

    test('prepares stable roles and words', () {
      final session = namedSession(setup.configForPlayerCount(6));
      expect(session.assignments.length, 6);
      expect(
        session.assignments.where((p) => p.role == PlayerRole.civilian).length,
        4,
      );
      expect(
        session.assignments
            .where((p) => p.role == PlayerRole.undercover)
            .length,
        1,
      );
      expect(
        session.assignments
            .where((p) => p.role == PlayerRole.misterWhite)
            .length,
        1,
      );
    });

    test('replay keeps names, theme and role distribution', () async {
      final flow = GameFlowService(random: Random(5));
      final previous = namedSession(setup.configForPlayerCount(6));
      final replay = await flow.prepareReplaySession(previousSession: previous);

      expect(
        replay.assignments.map((player) => player.name),
        previous.assignments.map((player) => player.name),
      );
      expect(replay.theme.id, previous.theme.id);
      expect(
        replay.assignments.where((p) => p.role == PlayerRole.undercover).length,
        previous.assignments
            .where((p) => p.role == PlayerRole.undercover)
            .length,
      );
      expect(
        replay.assignments.every((player) => !player.isEliminated),
        isTrue,
      );
      expect(replay.round, 1);
    });

    test(
      'adding a player preserves names and adds one civilian slot',
      () async {
        final flow = GameFlowService(random: Random(7));
        final previous = namedSession(setup.configForPlayerCount(6));
        final replay = await flow.prepareReplaySession(
          previousSession: previous,
          additionalPlayerName: 'New player',
        );

        expect(replay.assignments.length, 7);
        expect(replay.assignments.last.name, 'New player');
        expect(
          replay.assignments
              .where((p) => p.role == PlayerRole.undercover)
              .length,
          1,
        );
        expect(
          replay.assignments
              .where((p) => p.role == PlayerRole.misterWhite)
              .length,
          1,
        );
        expect(
          replay.assignments.where((p) => p.role == PlayerRole.civilian).length,
          5,
        );
      },
    );

    test('eliminated player is absent from alive players', () {
      final flow = GameFlowService(random: Random(1));
      final session = namedSession(setup.configForPlayerCount(6));
      final eliminated = flow.eliminatePlayer(session, 0);
      expect(eliminated.assignments[0].isEliminated, isTrue);
      expect(eliminated.alivePlayers.any((player) => player.id == 0), isFalse);
      expect(eliminated.round, 2);
    });

    test('civilians win after all special roles are eliminated', () {
      final flow = GameFlowService(random: Random(1));
      var session = namedSession(setup.configForPlayerCount(6));
      for (final player in session.assignments.where(
        (player) => player.role != PlayerRole.civilian,
      )) {
        session = flow.eliminatePlayer(session, player.id);
      }
      expect(flow.checkOutcome(session).type, GameOutcomeType.civiliansWin);
    });

    test('special roles win at equality and only survivors win', () {
      final flow = GameFlowService(random: Random(1));
      var session = namedSession(setup.configForPlayerCount(6));
      final civilians = session.assignments
          .where((player) => player.role == PlayerRole.civilian)
          .toList();
      session = flow.eliminatePlayer(session, civilians[0].id);
      session = flow.eliminatePlayer(session, civilians[1].id);
      final outcome = flow.checkOutcome(session);
      expect(outcome.type, GameOutcomeType.specialRolesWin);
      expect(outcome.winnerIds.length, 2);
      expect(
        outcome.winnerIds.every(
          (id) => session.assignments[id].role != PlayerRole.civilian,
        ),
        isTrue,
      );
    });

    test('game continues while civilians have a strict majority', () {
      final session = namedSession(setup.configForPlayerCount(6));
      expect(
        GameFlowService().checkOutcome(session).type,
        GameOutcomeType.inProgress,
      );
    });

    test('Mister White guess ignores accents case and extra spaces', () {
      final flow = GameFlowService(random: Random(1));
      final base = namedSession(setup.configForPlayerCount(6));
      final white = base.assignments.firstWhere(
        (player) => player.role == PlayerRole.misterWhite,
      );
      final session = GameSession(
        theme: base.theme,
        civilianWord: 'Cinéma',
        undercoverWord: base.undercoverWord,
        assignments: base.assignments,
        round: base.round,
      );
      final outcome = flow.checkMisterWhiteGuess(
        session,
        white.id,
        '  CINEMA  ',
      );
      expect(outcome.type, GameOutcomeType.misterWhiteGuessWin);
      expect(outcome.winnerIds, [white.id]);
    });
  });
}
