import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

class VoxCardsApp extends StatelessWidget {
  const VoxCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoxCards',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
