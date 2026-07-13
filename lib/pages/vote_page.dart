import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/game_board_page.dart';
import 'package:undercover/pages/result_page.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key, required this.session});

  final GameSession session;

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final _flow = GameFlowService();
  int? _selectedId;

  @override
  Widget build(BuildContext context) {
    final alive = widget.session.alivePlayers;
    return AppScaffold(
      title: 'Vote',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qui voulez-vous eliminer ?',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Le choix du groupe est definitif.',
              style: TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: alive.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.05,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final player = alive[index];
                  final selected = player.id == _selectedId;
                  return InkWell(
                    key: Key('vote-player-${player.id}'),
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selectedId = player.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.elevatedSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppTheme.accent
                              : const Color(0xFF283247),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            AppIcons.user,
                            color: AppTheme.primary,
                            size: 38,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            player.name,
                            textAlign: TextAlign.center,
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
              label: _selectedId == null
                  ? 'Selectionner un joueur'
                  : 'Eliminer',
              onPressed: _selectedId == null ? null : _eliminate,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _eliminate() async {
    final player = widget.session.assignments.firstWhere(
      (candidate) => candidate.id == _selectedId,
    );
    final eliminatedSession = _flow.eliminatePlayer(widget.session, player.id);
    final guessController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.elevatedSurface,
      builder: (sheetContext) {
        final isWhite = player.role == PlayerRole.misterWhite;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            22,
            22,
            22 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${player.name} etait ${player.role.label}',
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              if (isWhite) ...[
                const SizedBox(height: 10),
                const Text(
                  'Mister White peut tenter de deviner le mot des Civils.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 14),
                TextField(
                  key: const Key('mister-white-guess'),
                  controller: guessController,
                  decoration: const InputDecoration(
                    labelText: 'Mot des Civils',
                    filled: true,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              PrimaryActionButton(
                label: isWhite ? 'Valider la tentative' : 'Continuer',
                onPressed: () {
                  final outcome = isWhite
                      ? _flow.checkMisterWhiteGuess(
                          eliminatedSession,
                          player.id,
                          guessController.text,
                        )
                      : _flow.checkOutcome(eliminatedSession);
                  Navigator.of(sheetContext).pop();
                  _continueWith(_flow.applyOutcome(eliminatedSession, outcome));
                },
              ),
            ],
          ),
        );
      },
    );
    guessController.dispose();
  }

  void _continueWith(GameSession session) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => session.outcome.isFinished
            ? ResultPage(session: session)
            : GameBoardPage(session: session),
      ),
    );
  }
}
