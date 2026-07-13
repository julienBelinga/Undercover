import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/vote_page.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class GameBoardPage extends StatelessWidget {
  const GameBoardPage({super.key, required this.session});

  final GameSession session;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manche ${session.round}',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'La manche bat son plein',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Analysez les indices, puis eliminez un suspect.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: session.assignments.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.08,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final player = session.assignments[index];
                  return _PlayerTile(player: player);
                },
              ),
            ),
            const SizedBox(height: 14),
            PrimaryActionButton(
              label: 'Lancer le vote',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => VotePage(session: session),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  const _PlayerTile({required this.player});

  final PlayerAssignment player;

  @override
  Widget build(BuildContext context) {
    final alive = !player.isEliminated;
    return Opacity(
      key: Key('player-${player.id}'),
      opacity: alive ? 1 : 0.38,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF283247)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              alive ? AppIcons.user : AppIcons.close,
              color: alive ? AppTheme.primary : AppTheme.muted,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              player.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              alive ? 'Vivant' : 'Elimine',
              style: TextStyle(
                color: alive ? AppTheme.primary : AppTheme.muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
