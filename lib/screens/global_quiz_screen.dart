import 'package:flutter/material.dart';
import 'package:knhs_math_learning_app/data/mock_modules.dart';
import 'package:knhs_math_learning_app/screens/quiz_screen.dart';

class GlobalQuizScreen extends StatelessWidget {
  const GlobalQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final module = appModules[0];
    return Scaffold(
      appBar: AppBar(title: const Text("All Practice Quizzes")),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: module.topics.length,
        separatorBuilder: (c, i) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final topic = module.topics[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _MiniQuizBtn(topic: topic, level: 'easy', color: Colors.green)),
                      const SizedBox(width: 8),
                      Expanded(child: _MiniQuizBtn(topic: topic, level: 'medium', color: Colors.orange)),
                      const SizedBox(width: 8),
                      Expanded(child: _MiniQuizBtn(topic: topic, level: 'hard', color: Colors.red)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MiniQuizBtn extends StatelessWidget {
  final dynamic topic;
  final String level;
  final Color color;

  const _MiniQuizBtn({required this.topic, required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(topic: topic, difficulty: level))),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: (color.a * 0.1).clamp(0, 255)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: (color.a * 0.2).clamp(0, 255))),
        ),
        child: Text(level.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
