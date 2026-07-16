import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/feedback_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, this.feedbackService});

  final FeedbackService? feedbackService;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _messageController = TextEditingController();
  late final FeedbackService _feedbackService =
      widget.feedbackService ?? FeedbackService();
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
    await _feedbackService.submitBug(message);
    if (!mounted) return;
    _messageController.clear();
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Le bug a bien ete remonte, il sera traite dans les meilleurs delais.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Signaler un bug',
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(AppIcons.bug, color: AppTheme.primary, size: 56),
            const SizedBox(height: 14),
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
                  hintText: 'Ce qui s’est passe, quand, et sur quel ecran.',
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            PrimaryActionButton(
              label: _isSaving ? 'Envoi...' : 'Envoyer le bug',
              onPressed: _isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
