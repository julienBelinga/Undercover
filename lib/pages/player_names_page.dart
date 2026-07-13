import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/theme_selection_page.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/services/game_storage_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class PlayerNamesPage extends StatefulWidget {
  const PlayerNamesPage({super.key, required this.config});

  final GameSetupConfig config;

  @override
  State<PlayerNamesPage> createState() => _PlayerNamesPageState();
}

class _PlayerNamesPageState extends State<PlayerNamesPage> {
  static const _storage = GameStorageService();

  final List<TextEditingController> _controllers = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadNames() async {
    final names = await _storage.loadPlayerNames(widget.config.totalPlayers);
    if (!mounted) {
      return;
    }

    setState(() {
      _controllers
        ..clear()
        ..addAll(names.map((name) => TextEditingController(text: name)));
      _isLoading = false;
    });
  }

  Future<void> _continue() async {
    final names = List.generate(_controllers.length, (index) {
      final value = _controllers[index].text.trim();
      return value.isEmpty ? 'Joueur ${index + 1}' : value;
    });
    await _storage.savePlayerNames(names);

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ThemeSelectionPage(config: widget.config, names: names),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Undercover',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Qui joue ?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saisissez les prenoms des joueurs presents autour de la table.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _controllers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return TextField(
                          key: Key('player-name-${index + 1}'),
                          controller: _controllers[index],
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.elevatedSurface,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                backgroundColor: AppTheme.primary.withValues(
                                  alpha: 0.16,
                                ),
                                child: Text('${index + 1}'),
                              ),
                            ),
                            suffixIcon: IconButton(
                              tooltip: 'Effacer',
                              icon: const Icon(AppIcons.close),
                              onPressed: () => _controllers[index].clear(),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PrimaryActionButton(
                    label: 'Choisir un theme',
                    onPressed: _continue,
                  ),
                ],
              ),
      ),
    );
  }
}
