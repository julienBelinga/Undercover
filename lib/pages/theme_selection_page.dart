import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/distribution_page.dart';
import 'package:undercover/services/game_content_service.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/services/game_storage_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({
    super.key,
    required this.config,
    required this.names,
  });

  final GameSetupConfig config;
  final List<String> names;

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  static const _content = GameContentService();
  static const _storage = GameStorageService();

  late final List<WordTheme> _themes = _content.themes();
  late WordTheme _selectedTheme = _themes.first;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeId = await _storage.loadThemeId();
    if (!mounted || themeId == null) {
      return;
    }

    setState(() {
      _selectedTheme = _content.themeById(themeId);
    });
  }

  Future<void> _startDistribution() async {
    await _storage.saveThemeId(_selectedTheme.id);
    final session = GameFlowService().createSession(
      config: widget.config,
      playerNames: widget.names,
      theme: _selectedTheme,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DistributionPage(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nouvelle partie',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme de mots',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Choisis le paquet utilise pour cette manche.',
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
                  final isSelected = theme.id == _selectedTheme.id;
                  return _ThemeCard(
                    theme: theme,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedTheme = theme),
                  );
                },
              ),
            ),
            PrimaryActionButton(
              label: 'Distribuer les roles',
              onPressed: _startDistribution,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  final WordTheme theme;
  final bool isSelected;
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
            color: isSelected ? AppTheme.primary : const Color(0xFF283247),
            width: isSelected ? 2 : 1,
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
            if (isSelected) const Icon(AppIcons.vote, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}
