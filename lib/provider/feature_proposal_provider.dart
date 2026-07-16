import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undercover/services/feature_proposal_service.dart';

final featureProposalServiceProvider = Provider<FeatureProposalService>(
  (ref) => FeatureProposalService(),
);

final featureProposalsProvider =
    FutureProvider.autoDispose<List<FeatureProposal>>((ref) {
      final service = ref.watch(featureProposalServiceProvider);
      return service.loadProposals();
    });

final featureProposalCommentsProvider = FutureProvider.autoDispose
    .family<List<FeatureProposalComment>, String>((ref, proposalId) {
      final service = ref.watch(featureProposalServiceProvider);
      return service.loadComments(proposalId);
    });
