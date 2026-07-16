import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/feature_proposals_page.dart';
import 'package:undercover/pages/feedback_page.dart';
import 'package:undercover/pages/rules_page.dart';
import 'package:undercover/widgets/app_scaffold.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Aide',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _HelpTile(
            icon: AppIcons.rules,
            title: 'Regles du jeu',
            subtitle:
                'Objectifs, votes, Mister White et conditions de victoire',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const RulesPage())),
          ),
          const SizedBox(height: 12),
          _HelpTile(
            icon: AppIcons.bug,
            title: 'Signaler un bug',
            subtitle: 'Remonter un probleme rencontre dans l’app',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FeedbackPage()),
            ),
          ),
          const SizedBox(height: 12),
          _HelpTile(
            icon: AppIcons.idea,
            title: 'Propositions d’amelioration',
            subtitle: 'Poster, voter et commenter les idees de la communaute',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const FeatureProposalsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF283247)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const Icon(AppIcons.play, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}
