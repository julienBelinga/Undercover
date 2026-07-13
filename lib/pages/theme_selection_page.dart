import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/game_setup_page.dart';
import 'package:undercover/pages/distribution_page.dart';
import 'package:undercover/services/game_content_service.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_storage_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key, this.replaySession});

  final GameSession? replaySession;

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  static const _content = GameContentService();
  static const _storage = GameStorageService();
  late final List<WordTheme> _themes = _content.themes();
  String? _lastThemeId;

  @override
  void initState() {
    super.initState();
    _loadLastTheme();
  }

  Future<void> _loadLastTheme() async {
    final id = await _storage.loadThemeId();
    if (mounted) setState(() => _lastThemeId = id);
  }

  Future<void> _selectTheme(WordTheme theme) async {
    await _storage.saveThemeId(theme.id);
    if (!mounted) return;
    if (widget.replaySession != null) {
      final session = await GameFlowService().prepareReplaySession(
        previousSession: widget.replaySession!,
        theme: theme,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DistributionPage(session: session),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => GameSetupPage(theme: theme)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.replaySession == null ? 'Undercover' : 'Changer de theme',
      showBack: widget.replaySession != null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisis un theme',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Chaque theme contient son propre paquet de mots.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: _themes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final theme = _themes[index];
                  return _ThemeCard(
                    key: Key('theme-${theme.id}'),
                    theme: theme,
                    isLastUsed: theme.id == _lastThemeId,
                    onTap: () => _selectTheme(theme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    super.key,
    required this.theme,
    required this.isLastUsed,
    required this.onTap,
  });

  final WordTheme theme;
  final bool isLastUsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLastUsed ? AppTheme.primary : const Color(0xFF283247),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(theme.icon, color: theme.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const Icon(AppIcons.play, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}
