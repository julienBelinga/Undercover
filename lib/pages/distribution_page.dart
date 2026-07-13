import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/game_board_page.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key, required this.session});

  final GameSession session;

  @override
  State<DistributionPage> createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  var _index = 0;
  var _isRevealed = false;

  PlayerAssignment get _current => widget.session.assignments[_index];

  void _next() {
    if (!_isRevealed) {
      setState(() => _isRevealed = true);
      return;
    }

    if (_index == widget.session.assignments.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => GameBoardPage(session: widget.session),
        ),
      );
      return;
    }

    setState(() {
      _index += 1;
      _isRevealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _index + 1;
    return AppScaffold(
      title: 'Undercover',
      bottomBar: const AppBottomBar(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Attribution des roles',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / widget.session.assignments.length,
              color: AppTheme.primary,
              backgroundColor: const Color(0xFF283247),
            ),
            const SizedBox(height: 18),
            Text(
              'Passe le telephone a\n${_current.name}',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Assure-toi que personne ne regarde ton ecran.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _isRevealed
                    ? _RevealedCard(
                        key: ValueKey(_current.name),
                        player: _current,
                      )
                    : const _HiddenCard(key: ValueKey('hidden')),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryActionButton(
              label: _isRevealed
                  ? (_index == widget.session.assignments.length - 1
                        ? 'Lancer la partie'
                        : 'Joueur suivant')
                  : 'Reveler',
              onPressed: _next,
            ),
          ],
        ),
      ),
    );
  }
}

class _HiddenCard extends StatelessWidget {
  const _HiddenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Icon(AppIcons.reveal, color: AppTheme.primary, size: 76),
      ),
    );
  }
}

class _RevealedCard extends StatelessWidget {
  const _RevealedCard({super.key, required this.player});

  final PlayerAssignment player;

  @override
  Widget build(BuildContext context) {
    final roleColor = switch (player.role) {
      PlayerRole.civilian => AppTheme.primary,
      PlayerRole.undercover => AppTheme.accent,
      PlayerRole.misterWhite => AppTheme.violet,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: roleColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(color: roleColor.withValues(alpha: 0.18), blurRadius: 28),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_roleIcon(player.role), color: roleColor, size: 70),
          const SizedBox(height: 22),
          Text(
            player.role.label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.role.shortRule,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 26),
          Text(
            player.word,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  IconData _roleIcon(PlayerRole role) {
    return switch (role) {
      PlayerRole.civilian => AppIcons.user,
      PlayerRole.undercover => AppIcons.undercover,
      PlayerRole.misterWhite => AppIcons.misterWhite,
    };
  }
}
