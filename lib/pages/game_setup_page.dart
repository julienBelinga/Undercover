import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/player_names_page.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/services/game_storage_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/player_count_slider.dart';
import 'package:undercover/widgets/primary_action_button.dart';
import 'package:undercover/widgets/role_counter_card.dart';
import 'package:undercover/widgets/setup_summary_card.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage({super.key});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  static const _service = GameSetupService();
  static const _storage = GameStorageService();

  late GameSetupConfig _config = _service.initialConfig();
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final storedConfig = await _storage.loadConfig();
    if (!mounted) {
      return;
    }

    setState(() {
      _config = storedConfig ?? _service.initialConfig();
      _isLoading = false;
    });
  }

  void _updateConfig(GameSetupConfig config) {
    setState(() {
      _config = config;
    });
  }

  Future<void> _continue() async {
    await _storage.saveConfig(_config);
    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PlayerNamesPage(config: _config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nouvelle partie',
      showBack: false,
      bottomBar: const AppBottomBar(),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 6),
                        PlayerCountSlider(
                          value: _config.totalPlayers,
                          onChanged: (value) {
                            _updateConfig(_service.configForPlayerCount(value));
                          },
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Repartition des roles',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        RoleCounterCard(
                          title: 'Civils',
                          subtitle: 'Connaissent le mot',
                          value: _config.civilians,
                          icon: AppIcons.users,
                          accentColor: AppTheme.primary,
                        ),
                        const SizedBox(height: 12),
                        RoleCounterCard(
                          title: 'Undercover',
                          subtitle: 'Mot legerement different',
                          value: _config.undercovers,
                          icon: AppIcons.undercover,
                          accentColor: AppTheme.accent,
                          onDecrement: _service.canDecrementUndercover(_config)
                              ? () => _updateConfig(
                                  _service.decrementUndercover(_config),
                                )
                              : null,
                          onIncrement: _service.canIncrementUndercover(_config)
                              ? () => _updateConfig(
                                  _service.incrementUndercover(_config),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        RoleCounterCard(
                          title: 'Mr. White',
                          subtitle: 'N’a aucun mot',
                          value: _config.misterWhites,
                          icon: AppIcons.misterWhite,
                          accentColor: AppTheme.violet,
                          onDecrement: _service.canDecrementMisterWhite(_config)
                              ? () => _updateConfig(
                                  _service.decrementMisterWhite(_config),
                                )
                              : null,
                          onIncrement: _service.canIncrementMisterWhite(_config)
                              ? () => _updateConfig(
                                  _service.incrementMisterWhite(_config),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        SetupSummaryCard(config: _config),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryActionButton(
                    label: 'Commencer la partie',
                    onPressed: _config.isValid ? _continue : null,
                  ),
                ],
              ),
            ),
    );
  }
}
