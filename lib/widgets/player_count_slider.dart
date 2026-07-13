import 'package:flutter/material.dart';
import 'package:undercover/services/game_setup_service.dart';

class PlayerCountSlider extends StatelessWidget {
  const PlayerCountSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Joueurs',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$value',
                  key: const Key('player-count-value'),
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              key: const Key('player-count-slider'),
              value: value.toDouble(),
              min: GameSetupService.minPlayers.toDouble(),
              max: GameSetupService.maxPlayers.toDouble(),
              divisions:
                  GameSetupService.maxPlayers - GameSetupService.minPlayers,
              label: '$value joueurs',
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${GameSetupService.minPlayers} min'),
                Text('${GameSetupService.maxPlayers} max'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
