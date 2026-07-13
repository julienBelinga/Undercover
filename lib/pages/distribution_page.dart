import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/game_board_page.dart';
import 'package:undercover/services/game_flow_service.dart';
import 'package:undercover/services/game_storage_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

enum _DistributionStep { name, privateCard, revealed }

class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key, required this.session});

  final GameSession session;

  @override
  State<DistributionPage> createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final _flow = GameFlowService();
  final _nameController = TextEditingController();
  var _index = 0;
  var _step = _DistributionStep.name;
  String? _error;
  late GameSession _session = widget.session;

  PlayerAssignment get _current => _session.assignments[_index];

  @override
  void initState() {
    super.initState();
    if (_current.name.isNotEmpty) {
      _step = _DistributionStep.privateCard;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _confirmName() {
    final error = _flow.validatePlayerName(
      _session,
      _current.id,
      _nameController.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _session = _flow.assignPlayerName(
        _session,
        _current.id,
        _nameController.text,
      );
      _error = null;
      _step = _DistributionStep.privateCard;
    });
  }

  Future<void> _nextPlayer() async {
    if (_index == _session.assignments.length - 1) {
      await const GameStorageService().savePlayerNames(
        _session.assignments.map((player) => player.name).toList(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => GameBoardPage(session: _session),
        ),
      );
      return;
    }
    setState(() {
      _index += 1;
      _nameController.clear();
      _step = _current.name.isEmpty
          ? _DistributionStep.name
          : _DistributionStep.privateCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Joueur ${_index + 1}',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_index + 1) / _session.assignments.length,
              color: AppTheme.primary,
              backgroundColor: const Color(0xFF283247),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildStep(context)),
            const SizedBox(height: 18),
            PrimaryActionButton(
              label: switch (_step) {
                _DistributionStep.name => 'Valider le prenom',
                _DistributionStep.privateCard => 'Reveler ma carte',
                _DistributionStep.revealed =>
                  _index == _session.assignments.length - 1
                      ? 'Lancer la partie'
                      : 'Joueur suivant',
              },
              onPressed: switch (_step) {
                _DistributionStep.name => _confirmName,
                _DistributionStep.privateCard => () => setState(
                  () => _step = _DistributionStep.revealed,
                ),
                _DistributionStep.revealed => _nextPlayer,
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    if (_step == _DistributionStep.name) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.user, color: AppTheme.primary, size: 64),
          const SizedBox(height: 18),
          Text(
            'Comment tu t’appelles ?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          TextField(
            key: Key('player-name-${_index + 1}'),
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _confirmName(),
            decoration: InputDecoration(
              hintText: 'Prenom',
              errorText: _error,
              filled: true,
              fillColor: AppTheme.elevatedSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
    }

    if (_step == _DistributionStep.privateCard) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.reveal, color: AppTheme.primary, size: 76),
          const SizedBox(height: 22),
          Text(
            'Passe le telephone a\n${_current.name}',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Text(
            'Assure-toi que personne ne regarde.',
            style: TextStyle(color: AppTheme.muted),
          ),
        ],
      );
    }

    final roleColor = switch (_current.role) {
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_roleIcon(_current.role), color: roleColor, size: 70),
          const SizedBox(height: 20),
          Text(
            _current.role.label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(_current.role.shortRule, textAlign: TextAlign.center),
          const SizedBox(height: 26),
          Text(
            _current.word,
            key: const Key('secret-word'),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  IconData _roleIcon(PlayerRole role) => switch (role) {
    PlayerRole.civilian => AppIcons.user,
    PlayerRole.undercover => AppIcons.undercover,
    PlayerRole.misterWhite => AppIcons.misterWhite,
  };
}
