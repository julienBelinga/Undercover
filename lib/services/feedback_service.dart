import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum FeedbackKind { bug, idea }

class FeedbackDraft {
  const FeedbackDraft({
    required this.kind,
    required this.message,
    required this.createdAt,
  });

  final FeedbackKind kind;
  final String message;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'message': message,
    'created_at': createdAt.toIso8601String(),
  };
}

class FeedbackService {
  const FeedbackService();

  static const _feedbackKey = 'feedback_drafts';

  Future<void> saveDraft(FeedbackDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    final drafts = prefs.getStringList(_feedbackKey) ?? const [];
    await prefs.setStringList(_feedbackKey, [
      ...drafts,
      jsonEncode(draft.toJson()),
    ]);
  }
}
