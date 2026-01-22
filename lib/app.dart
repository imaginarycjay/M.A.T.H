import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

class TutoringHubApp extends StatelessWidget {
  const TutoringHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TutorHub',
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
