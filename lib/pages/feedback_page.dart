import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/feedback_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
    this.feedbackService = const FeedbackService(),
  });

  final FeedbackService feedbackService;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _messageController = TextEditingController();
  var _kind = FeedbackKind.bug;
  var _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      setState(() => _error = 'Ajoute quelques details.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });
    await widget.feedbackService.saveDraft(
      FeedbackDraft(kind: _kind, message: message, createdAt: DateTime.now()),
    );
    if (!mounted) return;
    _messageController.clear();
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Merci, ton retour est enregistre.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Retour',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<FeedbackKind>(
              segments: const [
                ButtonSegment(
                  value: FeedbackKind.bug,
                  icon: Icon(AppIcons.settings),
                  label: Text('Bug'),
                ),
                ButtonSegment(
                  value: FeedbackKind.idea,
                  icon: Icon(AppIcons.edit),
                  label: Text('Idee'),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (selection) {
                setState(() => _kind = selection.first);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                key: const Key('feedback-message'),
                controller: _messageController,
                expands: true,
                minLines: null,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Message',
                  hintText: 'Ce qui s’est passe, ou ce que tu veux ajouter.',
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            PrimaryActionButton(
              label: _isSaving ? 'Enregistrement...' : 'Envoyer',
              onPressed: _isSaving ? null : _submit,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enregistre localement pour cette V1.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
