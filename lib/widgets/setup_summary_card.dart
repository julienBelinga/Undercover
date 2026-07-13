import 'package:flutter/material.dart';
import 'package:undercover/services/game_setup_service.dart';

class SetupSummaryCard extends StatelessWidget {
  const SetupSummaryCard({super.key, required this.config});

  final GameSetupConfig config;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: config.isValid
            ? colorScheme.primaryContainer.withValues(alpha: 0.4)
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          config.validationMessage ??
              '${config.totalPlayers} joueurs - ${config.civilians} civils, '
                  '${config.undercovers} undercover, ${config.misterWhites} Mister White',
          key: const Key('setup-summary'),
          style: textTheme.bodyMedium?.copyWith(
            color: config.isValid
                ? colorScheme.onPrimaryContainer
                : colorScheme.onErrorContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
