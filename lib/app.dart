import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/learning_path_screen.dart';

class LearnMathApp extends StatelessWidget {
  const LearnMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MATH',
      theme: AppTheme.theme,
      home: const LearningPathScreen(),
    );
  }
}
