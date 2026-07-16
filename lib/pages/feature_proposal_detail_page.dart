import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/feature_proposal_form_page.dart';
import 'package:undercover/provider/feature_proposal_provider.dart';
import 'package:undercover/services/feature_proposal_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';

class FeatureProposalDetailPage extends ConsumerStatefulWidget {
  const FeatureProposalDetailPage({super.key, required this.proposal});

  final FeatureProposal proposal;

  @override
  ConsumerState<FeatureProposalDetailPage> createState() =>
      _FeatureProposalDetailPageState();
}

class _FeatureProposalDetailPageState
    extends ConsumerState<FeatureProposalDetailPage> {
  final _commentController = TextEditingController();
  var _isSending = false;
  var _isDeleting = false;
  String? _error;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty) {
      setState(() => _error = 'Ajoute un commentaire.');
      return;
    }

    setState(() {
      _isSending = true;
      _error = null;
    });
    try {
      await ref
          .read(featureProposalServiceProvider)
          .addComment(proposalId: widget.proposal.id, body: body);
      ref.invalidate(featureProposalCommentsProvider(widget.proposal.id));
      if (!mounted) return;
      _commentController.clear();
      setState(() => _isSending = false);
    } on AuthException catch (error) {
      setState(() {
        _isSending = false;
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _isSending = false;
        _error = 'Commentaire impossible pour le moment.';
      });
    }
  }

  Future<void> _editProposal() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FeatureProposalFormPage(proposal: widget.proposal),
      ),
    );
    if (!mounted) return;
    if (updated == true) {
      ref.invalidate(featureProposalsProvider);
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _deleteProposal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer la proposition ?'),
          content: const Text(
            'Cette action supprimera aussi ses votes et commentaires.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _isDeleting = true;
      _error = null;
    });
    try {
      await ref
          .read(featureProposalServiceProvider)
          .deleteProposal(widget.proposal.id);
      ref.invalidate(featureProposalsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on AuthException catch (error) {
      setState(() {
        _isDeleting = false;
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _isDeleting = false;
        _error = 'Suppression impossible pour le moment.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final proposal = widget.proposal;
    final comments = ref.watch(featureProposalCommentsProvider(proposal.id));
    return AppScaffold(
      title: 'Proposition',
      showBack: true,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              children: [
                Text(
                  proposal.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${proposal.score} votes',
                  style: const TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 16),
                Text(proposal.body),
                if (proposal.isMine) ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isDeleting ? null : _editProposal,
                          icon: const Icon(AppIcons.edit),
                          label: const Text('Modifier'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isDeleting ? null : _deleteProposal,
                          icon: const Icon(AppIcons.close),
                          label: Text(
                            _isDeleting ? 'Suppression...' : 'Supprimer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(AppIcons.comment, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Commentaires',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                comments.when(
                  loading: () {
                    return const Padding(
                      padding: EdgeInsets.all(18),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  error: (_, _) {
                    return const Text('Commentaires indisponibles.');
                  },
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          'Aucun commentaire.',
                          style: TextStyle(color: AppTheme.muted),
                        ),
                      );
                    }
                    return Column(
                      children: comments
                          .map((comment) => _CommentTile(comment: comment))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Column(
                children: [
                  TextField(
                    key: const Key('feature-comment'),
                    controller: _commentController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Commentaire',
                      suffixIcon: IconButton(
                        tooltip: 'Envoyer',
                        onPressed: _isSending ? null : _submitComment,
                        icon: const Icon(AppIcons.play),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final FeatureProposalComment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF283247)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Anonyme', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(comment.body),
        ],
      ),
    );
  }
}
