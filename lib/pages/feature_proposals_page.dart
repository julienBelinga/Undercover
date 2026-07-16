import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/account_page.dart';
import 'package:undercover/pages/feature_proposal_detail_page.dart';
import 'package:undercover/pages/feature_proposal_form_page.dart';
import 'package:undercover/provider/feature_proposal_provider.dart';
import 'package:undercover/services/feature_proposal_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';

class FeatureProposalsPage extends ConsumerWidget {
  const FeatureProposalsPage({super.key});

  Future<void> _vote(
    BuildContext context,
    WidgetRef ref,
    FeatureProposal proposal,
    int vote,
  ) async {
    try {
      await ref
          .read(featureProposalServiceProvider)
          .vote(
            proposalId: proposal.id,
            vote: vote,
            currentVote: proposal.myVote,
          );
      ref.invalidate(featureProposalsProvider);
    } on AuthException catch (error) {
      if (!context.mounted) return;
      _showMessage(context, error.message);
    } catch (_) {
      if (!context.mounted) return;
      _showMessage(context, 'Vote impossible pour le moment.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openCreateForm(BuildContext context, WidgetRef ref) async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const FeatureProposalFormPage()),
    );
    if (created == true) ref.invalidate(featureProposalsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposals = ref.watch(featureProposalsProvider);
    return AppScaffold(
      title: 'Ameliorations',
      showBack: true,
      child: proposals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) {
          return _SignInRequired(
            onOpenAccount: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AccountPage()),
              );
            },
          );
        },
        data: (proposals) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openCreateForm(context, ref),
                    icon: const Icon(AppIcons.edit),
                    label: const Text('Proposer une amelioration'),
                  ),
                ),
              ),
              Expanded(
                child: proposals.isEmpty
                    ? const Center(
                        child: Text('Aucune proposition pour le moment.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: proposals.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final proposal = proposals[index];
                          return _ProposalCard(
                            proposal: proposal,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => FeatureProposalDetailPage(
                                    proposal: proposal,
                                  ),
                                ),
                              );
                              ref.invalidate(featureProposalsProvider);
                            },
                            onUpvote: () => _vote(context, ref, proposal, 1),
                            onDownvote: () => _vote(context, ref, proposal, -1),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SignInRequired extends StatelessWidget {
  const _SignInRequired({required this.onOpenAccount});

  final VoidCallback onOpenAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.user, color: AppTheme.primary, size: 64),
          const SizedBox(height: 16),
          Text(
            'Compte requis',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connecte-toi pour poster, voter et commenter les ameliorations.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.muted),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onOpenAccount,
            icon: const Icon(AppIcons.user),
            label: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.onTap,
    required this.onUpvote,
    required this.onDownvote,
  });

  final FeatureProposal proposal;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF283247)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VoteRail(
              score: proposal.score,
              myVote: proposal.myVote,
              onUpvote: onUpvote,
              onDownvote: onDownvote,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposal.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    proposal.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(AppIcons.play, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}

class _VoteRail extends StatelessWidget {
  const _VoteRail({
    required this.score,
    required this.myVote,
    required this.onUpvote,
    required this.onDownvote,
  });

  final int score;
  final int? myVote;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      child: Column(
        children: [
          IconButton(
            tooltip: 'Upvote',
            onPressed: onUpvote,
            icon: Icon(
              AppIcons.upvote,
              color: myVote == 1 ? AppTheme.primary : AppTheme.muted,
            ),
          ),
          Text('$score', style: const TextStyle(fontWeight: FontWeight.w900)),
          IconButton(
            tooltip: 'Downvote',
            onPressed: onDownvote,
            icon: Icon(
              AppIcons.downvote,
              color: myVote == -1 ? AppTheme.accent : AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
