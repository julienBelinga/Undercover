import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:undercover/main.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/game_setup_page.dart';
import 'package:undercover/pages/player_names_page.dart';
import 'package:undercover/services/game_content_service.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_setup_service.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('MyApp opens the game setup page', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.byType(GameSetupPage), findsOneWidget);
    expect(find.text('Nouvelle partie'), findsOneWidget);
  });

  testWidgets('default setup uses 6 valid players', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byKey(const Key('player-count-value')), findsOneWidget);
    expect(find.text('6'), findsWidgets);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.textContaining('6 joueurs'), findsWidgets);
  });

  testWidgets('slider recomputes a valid setup', (WidgetTester tester) async {
    await pumpApp(tester);

    final slider = tester.widget<Slider>(
      find.byKey(const Key('player-count-slider')),
    );
    slider.onChanged?.call(10);
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining('10 joueurs'), findsWidgets);
  });

  testWidgets('role buttons cannot produce an invalid setup', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Retirer Undercover'));
    await tester.pump();

    expect(find.textContaining('1 undercover'), findsOneWidget);

    final removeMisterWhite = find.byTooltip('Retirer Mr. White');
    await tester.ensureVisible(removeMisterWhite);
    await tester.tap(removeMisterWhite);
    await tester.pump();
    await tester.tap(removeMisterWhite);
    await tester.pump();

    expect(find.textContaining('0 Mister White'), findsOneWidget);
    expect(find.textContaining('Il faut'), findsNothing);
  });

  testWidgets('setup continues to the player names page', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Commencer la partie'));
    await tester.pumpAndSettle();

    expect(find.byType(PlayerNamesPage), findsOneWidget);
    expect(find.text('Qui joue ?'), findsOneWidget);
    expect(find.byKey(const Key('player-name-1')), findsOneWidget);
  });

  group('GameSetupService', () {
    const service = GameSetupService();

    test('clamps player count to bounds', () {
      expect(service.configForPlayerCount(1).totalPlayers, 3);
      expect(service.configForPlayerCount(30).totalPlayers, 20);
    });

    test('computes default role distributions', () {
      expect(service.configForPlayerCount(3).civilians, 2);
      expect(service.configForPlayerCount(3).undercovers, 1);
      expect(service.configForPlayerCount(3).misterWhites, 0);

      expect(service.configForPlayerCount(6).civilians, 4);
      expect(service.configForPlayerCount(6).undercovers, 1);
      expect(service.configForPlayerCount(6).misterWhites, 1);

      expect(service.configForPlayerCount(10).civilians, 7);
      expect(service.configForPlayerCount(10).undercovers, 2);
      expect(service.configForPlayerCount(10).misterWhites, 1);
    });

    test('recomputes civilians after role changes', () {
      final config = service.incrementUndercover(
        service.configForPlayerCount(6),
      );

      expect(config.civilians, 3);
      expect(config.undercovers, 2);
      expect(config.misterWhites, 1);
      expect(config.isValid, isTrue);
    });

    test('allows a setup without Mister White', () {
      final config = service.decrementMisterWhite(
        service.configForPlayerCount(6),
      );

      expect(config.misterWhites, 0);
      expect(config.civilians, 5);
      expect(config.isValid, isTrue);
    });

    test('does not allow zero civilians or zero undercovers', () {
      var config = service.configForPlayerCount(3);

      config = service.incrementMisterWhite(config);
      config = service.incrementMisterWhite(config);
      expect(config.civilians, 1);

      config = service.decrementUndercover(config);
      expect(config.undercovers, 1);
      expect(config.isValid, isTrue);
    });
  });

  test('GameFlowService creates a session with expected role counts', () {
    const setupService = GameSetupService();
    const contentService = GameContentService();
    final session = GameFlowService().createSession(
      config: setupService.configForPlayerCount(6),
      playerNames: const ['A', 'B', 'C', 'D', 'E', 'F'],
      theme: contentService.themes().first,
    );

    expect(session.assignments.length, 6);
    expect(
      session.assignments.where((p) => p.role == PlayerRole.civilian).length,
      4,
    );
    expect(
      session.assignments.where((p) => p.role == PlayerRole.undercover).length,
      1,
    );
    expect(
      session.assignments.where((p) => p.role == PlayerRole.misterWhite).length,
      1,
    );
  });
}
