import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/widgets/app_scaffold.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Regles',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          _RuleBlock(
            icon: AppIcons.theme,
            title: 'Objectif',
            text:
                'Les Civils doivent trouver tous les Undercover et Mister White. Les roles speciaux doivent survivre assez longtemps pour prendre l’avantage.',
          ),
          _RuleBlock(
            icon: AppIcons.reveal,
            title: 'Distribution',
            text:
                'Chaque joueur regarde sa carte en secret. Les Civils ont le meme mot, les Undercover ont un mot proche, Mister White n’a aucun mot.',
          ),
          _RuleBlock(
            icon: AppIcons.vote,
            title: 'Debat et vote',
            text:
                'Les joueurs discutent, puis le groupe elimine une personne. Le role du joueur elimine est revele, pas son mot.',
          ),
          _RuleBlock(
            icon: AppIcons.misterWhite,
            title: 'Mister White',
            text:
                'Si Mister White est elimine, il peut tenter de deviner le mot des Civils. Une bonne reponse lui donne la victoire immediatement.',
          ),
          _RuleBlock(
            icon: AppIcons.users,
            title: 'Victoire',
            text:
                'Les Civils gagnent quand il ne reste plus aucun role special. Ils perdent si leur nombre devient inferieur ou egal aux roles speciaux encore en jeu.',
          ),
        ],
      ),
    );
  }
}

class _RuleBlock extends StatelessWidget {
  const _RuleBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 6),
                  Text(text, style: const TextStyle(color: AppTheme.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
