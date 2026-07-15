import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/pages/account_page.dart';
import 'package:undercover/pages/help_page.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    this.showBack = false,
    this.bottomBar,
    required this.child,
  });

  final String title;
  final Widget child;
  final bool showBack;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: showBack ? 'Retour' : 'Compte',
                    onPressed: showBack
                        ? () => Navigator.of(context).pop()
                        : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AccountPage(),
                            ),
                          ),
                    icon: Icon(showBack ? AppIcons.back : AppIcons.user),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Aide',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const HelpPage()),
                    ),
                    icon: const Icon(AppIcons.rules),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF071022),
        boxShadow: [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _BottomItem(icon: AppIcons.home, label: 'Home'),
          _BottomItem(icon: AppIcons.newGame, label: 'New Game', active: true),
          _BottomItem(icon: AppIcons.rules, label: 'Rules'),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.primary : AppTheme.muted;

    return Container(
      padding: active
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 7)
          : EdgeInsets.zero,
      decoration: active
          ? BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(28),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? const Color(0xFF062111) : color, size: 20),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF062111) : color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
