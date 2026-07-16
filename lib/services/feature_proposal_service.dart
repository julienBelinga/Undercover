import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/supabase_config.dart';

class FeatureProposal {
  const FeatureProposal({
    required this.id,
    required this.title,
    required this.body,
    required this.emitterAuthUserId,
    required this.emitterName,
    required this.emitterMail,
    required this.upvote,
    required this.downvote,
    required this.createdAt,
    this.myVote,
    this.isMine = false,
  });

  final String id;
  final String title;
  final String body;
  final String emitterAuthUserId;
  final String emitterName;
  final String emitterMail;
  final int upvote;
  final int downvote;
  final DateTime createdAt;
  final int? myVote;
  final bool isMine;

  int get score => upvote - downvote;

  FeatureProposal copyWith({
    int? myVote,
    bool? isMine,
    bool clearMyVote = false,
  }) {
    return FeatureProposal(
      id: id,
      title: title,
      body: body,
      emitterAuthUserId: emitterAuthUserId,
      emitterName: emitterName,
      emitterMail: emitterMail,
      upvote: upvote,
      downvote: downvote,
      createdAt: createdAt,
      myVote: clearMyVote ? null : myVote ?? this.myVote,
      isMine: isMine ?? this.isMine,
    );
  }

  static FeatureProposal fromRow(Map<String, dynamic> row) {
    return FeatureProposal(
      id: row['id'] as String,
      title: row['title'] as String,
      body: row['body'] as String,
      emitterAuthUserId: row['emitter_auth_user_id'] as String,
      emitterName: row['emitter_name'] as String,
      emitterMail: row['emitter_mail'] as String,
      upvote: row['upvote'] as int,
      downvote: row['downvote'] as int,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}

class FeatureProposalComment {
  const FeatureProposalComment({
    required this.id,
    required this.body,
    required this.emitterName,
    required this.emitterMail,
    required this.createdAt,
  });

  final String id;
  final String body;
  final String emitterName;
  final String emitterMail;
  final DateTime createdAt;

  static FeatureProposalComment fromRow(Map<String, dynamic> row) {
    return FeatureProposalComment(
      id: row['id'] as String,
      body: row['body'] as String,
      emitterName: row['emitter_name'] as String,
      emitterMail: row['emitter_mail'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}

class FeatureProposalService {
  FeatureProposalService({SupabaseClient? client}) : _supabaseClient = client;

  SupabaseClient? _supabaseClient;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _supabaseClient ??= Supabase.instance.client;
  }

  bool get isSignedIn => _supabase?.auth.currentUser != null;

  Future<List<FeatureProposal>> loadProposals() async {
    final client = _requireClient();
    final user = client.auth.currentUser!;

    final rows = await client
        .from('feature_proposals')
        .select()
        .order('upvote', ascending: false)
        .order('downvote')
        .order('created_at', ascending: false);
    final votes = await client
        .from('feature_proposal_votes')
        .select('proposal_id, vote')
        .eq('voter_auth_user_id', user.id);
    final votesByProposal = {
      for (final row in votes) row['proposal_id'] as String: row['vote'] as int,
    };
    final proposals =
        rows.map<FeatureProposal>((row) {
          final proposal = FeatureProposal.fromRow(
            Map<String, dynamic>.from(row as Map),
          );
          return proposal.copyWith(
            myVote: votesByProposal[row['id']],
            clearMyVote: !votesByProposal.containsKey(row['id']),
            isMine: proposal.emitterAuthUserId == user.id,
          );
        }).toList()..sort((a, b) {
          final scoreComparison = b.score.compareTo(a.score);
          if (scoreComparison != 0) return scoreComparison;
          return b.createdAt.compareTo(a.createdAt);
        });
    return proposals;
  }

  Future<void> createProposal({
    required String title,
    required String body,
  }) async {
    final client = _requireClient();
    final user = client.auth.currentUser!;
    await client.from('feature_proposals').insert({
      'title': title.trim(),
      'body': body.trim(),
      'emitter_auth_user_id': user.id,
      'emitter_name': _displayNameFor(user),
      'emitter_mail': user.email ?? '',
    });
  }

  Future<void> updateProposal({
    required String proposalId,
    required String title,
    required String body,
  }) async {
    final client = _requireClient();
    final user = client.auth.currentUser!;
    await client
        .from('feature_proposals')
        .update({'title': title.trim(), 'body': body.trim()})
        .eq('id', proposalId)
        .eq('emitter_auth_user_id', user.id);
  }

  Future<void> deleteProposal(String proposalId) async {
    final client = _requireClient();
    final user = client.auth.currentUser!;
    await client
        .from('feature_proposals')
        .delete()
        .eq('id', proposalId)
        .eq('emitter_auth_user_id', user.id);
  }

  Future<void> vote({
    required String proposalId,
    required int vote,
    int? currentVote,
  }) async {
    final client = _requireClient();
    final user = client.auth.currentUser!;
    if (currentVote == vote) {
      await client
          .from('feature_proposal_votes')
          .delete()
          .eq('proposal_id', proposalId)
          .eq('voter_auth_user_id', user.id);
      return;
    }
    await client.from('feature_proposal_votes').upsert({
      'proposal_id': proposalId,
      'voter_auth_user_id': user.id,
      'vote': vote,
    }, onConflict: 'proposal_id,voter_auth_user_id');
  }

  Future<List<FeatureProposalComment>> loadComments(String proposalId) async {
    final client = _requireClient();
    final rows = await client
        .from('feature_proposal_comments')
        .select()
        .eq('proposal_id', proposalId)
        .order('created_at');
    return rows
        .map<FeatureProposalComment>(
          (row) => FeatureProposalComment.fromRow(
            Map<String, dynamic>.from(row as Map),
          ),
        )
        .toList();
  }

  Future<void> addComment({
    required String proposalId,
    required String body,
  }) async {
    final client = _requireClient();
    final user = client.auth.currentUser!;
    await client.from('feature_proposal_comments').insert({
      'proposal_id': proposalId,
      'emitter_auth_user_id': user.id,
      'emitter_name': _displayNameFor(user),
      'emitter_mail': user.email ?? '',
      'body': body.trim(),
    });
  }

  SupabaseClient _requireClient() {
    final client = _supabase;
    if (client == null) {
      throw const AuthException('Supabase n’est pas configure.');
    }
    if (client.auth.currentUser == null) {
      throw const AuthException('Connecte-toi pour acceder aux propositions.');
    }
    return client;
  }

  String _displayNameFor(User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final metadataName =
        metadata['name'] ?? metadata['full_name'] ?? metadata['user_name'];
    if (metadataName is String && metadataName.trim().isNotEmpty) {
      return metadataName.trim();
    }
    final email = user.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'Utilisateur';
  }
}
