import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knhs_math_learning_app/models/topic.dart';
import 'package:knhs_math_learning_app/theme/app_theme.dart';
import 'package:knhs_math_learning_app/screens/quiz_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title.split(':')[0])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      border: Border(bottom: BorderSide(color: AppTheme.border)),
                    ),
                    child: const Text(
                      "LESSON CONTENT",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppTheme.muted),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: topic.content,
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("EXAMPLE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppTheme.muted)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.border),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            topic.example,
                            style: GoogleFonts.jetBrainsMono(fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Take a Quiz", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _QuizLevelBtn(topic: topic, level: 'easy', color: Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _QuizLevelBtn(topic: topic, level: 'medium', color: Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: _QuizLevelBtn(topic: topic, level: 'hard', color: Colors.red)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _QuizLevelBtn extends StatelessWidget {
  final Topic topic;
  final String level;
  final Color color;

  const _QuizLevelBtn({required this.topic, required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(topic: topic, difficulty: level)));
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: color.alpha * 0.001 + 0.1),
          border: Border.all(color: color.withValues(alpha: color.alpha * 0.001 + 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              level.toUpperCase(),
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
