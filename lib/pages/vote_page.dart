import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key, required this.session});

  final GameSession session;

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  PlayerAssignment? _selected;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Undercover',
      showBack: true,
      bottomBar: const AppBottomBar(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Qui est l’imposteur ?',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Analysez les regards, debusquez les mensonges.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: GridView.builder(
                itemCount: widget.session.alivePlayers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.05,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final player = widget.session.alivePlayers[index];
                  final isSelected = player.name == _selected?.name;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selected = player),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.elevatedSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accent
                              : const Color(0xFF283247),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppTheme.primary.withValues(
                              alpha: 0.16,
                            ),
                            child: Text(
                              player.name.characters.first.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            player.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            PrimaryActionButton(
              label: _selected == null ? 'Selectionner un joueur' : 'Eliminer',
              onPressed: _selected == null ? null : () => _showResult(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context) {
    final player = _selected!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.elevatedSurface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${player.name} etait ${player.role.label}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Mot secret : ${player.word}',
                style: const TextStyle(color: AppTheme.muted),
              ),
              const SizedBox(height: 18),
              PrimaryActionButton(
                label: 'Continuer',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
