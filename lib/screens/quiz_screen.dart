import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/topic.dart';
import '../theme/app_theme.dart';
import '../data/module_repository.dart';

class QuizScreen extends StatefulWidget {
  final Topic topic;
  final String difficulty;

  const QuizScreen({super.key, required this.topic, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ModuleRepository _repository = ModuleRepository();
  int currentIndex = 0;
  int? selectedIndex;
  bool isChecked = false;
  int score = 0;

  List<Question> get questions => widget.topic.quizzes[widget.difficulty]!;

  void checkAnswer() {
    if (selectedIndex == null) return;
    setState(() {
      isChecked = true;
      if (selectedIndex == questions[currentIndex].correctIndex) {
        score++;
      }
    });
  }

  Future<void> nextQuestion() async {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        isChecked = false;
      });
    } else {
      // Save quiz attempt to database
      await _repository.saveQuizAttempt(
        topicId: widget.topic.id,
        difficulty: widget.difficulty,
        score: score,
        total: questions.length,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Complete!"),
          content: Text("You scored $score out of ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Done"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.difficulty.toUpperCase()} Quiz"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text("${currentIndex + 1}/${questions.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            ...List.generate(question.options.length, (index) {
              Color borderColor = AppTheme.border;
              Color bgColor = Colors.white;

              if (isChecked) {
                if (index == question.correctIndex) {
                  borderColor = Colors.green;
                  bgColor = Colors.green.shade50;
                } else if (index == selectedIndex && index != question.correctIndex) {
                  borderColor = Colors.red;
                  bgColor = Colors.red.shade50;
                }
              } else if (selectedIndex == index) {
                borderColor = AppTheme.primary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: isChecked ? null : () => setState(() => selectedIndex = index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor, width: (isChecked && index == question.correctIndex) ? 2 : 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (isChecked && index == question.correctIndex)
                          const Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.check, size: 16, color: Colors.green)),
                        Expanded(child: Text(question.options[index], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (isChecked)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade100)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(question.explanation, style: const TextStyle(color: Colors.blue, fontSize: 13))),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == null ? null : (isChecked ? nextQuestion : checkAnswer),
                child: Text(isChecked ? (currentIndex == questions.length - 1 ? "Finish" : "Next") : "Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

