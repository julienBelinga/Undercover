import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/provider/feature_proposal_provider.dart';
import 'package:undercover/services/feature_proposal_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class FeatureProposalFormPage extends ConsumerStatefulWidget {
  const FeatureProposalFormPage({super.key, this.proposal});

  final FeatureProposal? proposal;

  @override
  ConsumerState<FeatureProposalFormPage> createState() =>
      _FeatureProposalFormPageState();
}

class _FeatureProposalFormPageState
    extends ConsumerState<FeatureProposalFormPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  var _isSaving = false;
  String? _error;

  bool get _isEditing => widget.proposal != null;

  @override
  void initState() {
    super.initState();
    final proposal = widget.proposal;
    if (proposal != null) {
      _titleController.text = proposal.title;
      _bodyController.text = proposal.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      setState(() => _error = 'Ajoute un titre et une description.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final service = ref.read(featureProposalServiceProvider);
      final proposal = widget.proposal;
      if (proposal == null) {
        await service.createProposal(title: title, body: body);
      } else {
        await service.updateProposal(
          proposalId: proposal.id,
          title: title,
          body: body,
        );
      }
      ref.invalidate(featureProposalsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on AuthException catch (error) {
      setState(() {
        _isSaving = false;
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _isSaving = false;
        _error = 'Proposition impossible pour le moment.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _isEditing ? 'Modifier' : 'Nouvelle idee',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(AppIcons.idea, color: AppTheme.primary, size: 56),
            const SizedBox(height: 14),
            TextField(
              key: const Key('feature-title'),
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                key: const Key('feature-body'),
                controller: _bodyController,
                expands: true,
                minLines: null,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  hintText: 'Explique le besoin ou le probleme a resoudre.',
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            PrimaryActionButton(
              label: _isSaving
                  ? (_isEditing ? 'Modification...' : 'Publication...')
                  : (_isEditing ? 'Enregistrer' : 'Publier'),
              onPressed: _isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
