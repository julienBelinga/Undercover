import 'package:flutter/material.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/pages/game_setup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const GameSetupPage(),
    );
  }
}
