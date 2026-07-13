import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/theme_selection_page.dart';
import 'package:undercover/pages/distribution_page.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_setup_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.session});

  final GameSession session;

  @override
  Widget build(BuildContext context) {
    final winners = session.assignments
        .where((player) => session.outcome.winnerIds.contains(player.id))
        .toList();
    return AppScaffold(
      title: 'Fin de partie',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            const Icon(AppIcons.vote, color: AppTheme.primary, size: 64),
            const SizedBox(height: 14),
            Text(
              _title(session.outcome.type),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Gagnants : ${winners.map((player) => player.name).join(', ')}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: session.assignments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final player = session.assignments[index];
                  final won = session.outcome.winnerIds.contains(player.id);
                  return ListTile(
                    tileColor: AppTheme.elevatedSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Icon(
                      _icon(player.role),
                      color: won ? AppTheme.primary : AppTheme.muted,
                    ),
                    title: Text(player.name),
                    subtitle: Text(player.role.label),
                    trailing: won
                        ? const Icon(AppIcons.vote, color: AppTheme.primary)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            PrimaryActionButton(
              label: 'Rejouer',
              onPressed: () async {
                final replaySession = await GameFlowService()
                    .prepareReplaySession(previousSession: session);
                if (!context.mounted) return;
                _startDistribution(context, replaySession);
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => ThemeSelectionPage(replaySession: session),
                  ),
                  (_) => false,
                ),
                icon: const Icon(AppIcons.theme),
                label: const Text('Changer de theme'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed:
                    session.assignments.length >= GameSetupService.maxPlayers
                    ? null
                    : () => _showAddPlayer(context),
                icon: const Icon(AppIcons.newGame),
                label: const Text('Ajouter un joueur'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(GameOutcomeType type) => switch (type) {
    GameOutcomeType.civiliansWin => 'Les Civils gagnent',
    GameOutcomeType.specialRolesWin => 'Les roles speciaux gagnent',
    GameOutcomeType.misterWhiteGuessWin => 'Mister White gagne',
    GameOutcomeType.inProgress => 'Partie en cours',
  };

  IconData _icon(PlayerRole role) => switch (role) {
    PlayerRole.civilian => AppIcons.user,
    PlayerRole.undercover => AppIcons.undercover,
    PlayerRole.misterWhite => AppIcons.misterWhite,
  };

  void _startDistribution(BuildContext context, GameSession newSession) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => DistributionPage(session: newSession),
      ),
      (_) => false,
    );
  }

  Future<void> _showAddPlayer(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _AddPlayerDialog(session: session),
    );
    if (name == null || !context.mounted) return;
    final replaySession = await GameFlowService().prepareReplaySession(
      previousSession: session,
      additionalPlayerName: name,
    );
    if (!context.mounted) return;
    _startDistribution(context, replaySession);
  }
}

class _AddPlayerDialog extends StatefulWidget {
  const _AddPlayerDialog({required this.session});

  final GameSession session;

  @override
  State<_AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<_AddPlayerDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final validation = GameFlowService().validatePlayerName(
      widget.session,
      -1,
      _controller.text,
    );
    if (validation != null) {
      setState(() => _error = validation);
      return;
    }
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un joueur'),
      content: TextField(
        key: const Key('additional-player-name'),
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(labelText: 'Prenom', errorText: _error),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Ajouter')),
      ],
    );
  }
}
