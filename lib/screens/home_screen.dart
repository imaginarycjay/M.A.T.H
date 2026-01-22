import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:knhs_math_learning_app/screens/module_screen.dart';
import 'package:knhs_math_learning_app/screens/global_quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calculate_outlined, size: 20),
            SizedBox(width: 8),
            Text('TutorHub'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Student!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "DepEd Module 1: Key Concept of Functions",
              style: TextStyle(color: AppTheme.muted, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _HomeCard(
                    title: "Module 1",
                    icon: Icons.book_outlined,
                    subtitle: "4 Lessons",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ModuleScreen())),
                  ),
                  _HomeCard(
                    title: "Quizzes",
                    icon: Icons.quiz_outlined,
                    subtitle: "Easy • Med • Hard",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalQuizScreen())),
                  ),
                  _HomeCard(
                    title: "Statistics",
                    icon: Icons.bar_chart_outlined,
                    subtitle: "Track Progress",
                    onTap: () {},
                  ),
                  _HomeCard(
                    title: "Study Plan",
                    icon: Icons.calendar_today_outlined,
                    subtitle: "Your Schedule",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
