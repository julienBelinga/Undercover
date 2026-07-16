import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/supabase_config.dart';

class BugReport {
  const BugReport({required this.message, required this.createdAt});

  final String message;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'message': message,
    'created_at': createdAt.toIso8601String(),
  };
}

class FeedbackService {
  FeedbackService({SupabaseClient? client}) : _supabaseClient = client;

  static const _bugReportKey = 'bug_report_drafts';
  SupabaseClient? _supabaseClient;

  SupabaseClient? get _supabase {
    if (!SupabaseConfig.isConfigured) return null;
    return _supabaseClient ??= Supabase.instance.client;
  }

  Future<void> submitBug(String message) async {
    final report = BugReport(message: message, createdAt: DateTime.now());
    final client = _supabase;
    if (client == null) {
      await _saveDraft(report);
      return;
    }

    final user = client.auth.currentUser;
    try {
      await client
          .from('bug_reports')
          .insert({
            'message': message,
            'reporter_auth_user_id': user?.id,
            'reporter_name': _displayNameFor(user),
            'reporter_mail': user?.email,
            'app_context': {
              'platform': 'flutter',
              'created_at': report.createdAt.toIso8601String(),
            },
          })
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      await _saveDraft(report);
    }
  }

  Future<void> _saveDraft(BugReport report) async {
    final prefs = await SharedPreferences.getInstance();
    final drafts = prefs.getStringList(_bugReportKey) ?? const [];
    await prefs.setStringList(_bugReportKey, [
      ...drafts,
      jsonEncode(report.toJson()),
    ]);
  }

  String? _displayNameFor(User? user) {
    if (user == null) return null;
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
    return null;
  }
}
