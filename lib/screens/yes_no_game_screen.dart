import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/learning_node.dart';
import '../data/learning_database.dart';

class YesNoGameScreen extends StatefulWidget {
  final LearningNode node;

  const YesNoGameScreen({super.key, required this.node});

  @override
  State<YesNoGameScreen> createState() => _YesNoGameScreenState();
}

class _YesNoGameScreenState extends State<YesNoGameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool? _answered;
  bool _showResult = false;

  List<YesNoQuestion> get questions => widget.node.yesNoQuestions ?? [];

  void _answer(bool answer) async {
    if (_answered != null) return;

    final correct = questions[_currentIndex].answer;
    setState(() {
      _answered = answer;
      if (answer == correct) {
        _score++;
      }
    });

    // Wait a moment to show feedback
    await Future.delayed(const Duration(milliseconds: 1200));

    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = null;
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    setState(() => _showResult = true);

    // Need all correct to pass
    final passed = _score == questions.length;

    if (passed) {
      await LearningDatabase.instance.completeNode(
        widget.node.id,
        score: ((_score / questions.length) * 100).round(),
      );
    } else {
      await LearningDatabase.instance.recordFailedAttempt(
        widget.node.id,
        score: ((_score / questions.length) * 100).round(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    final question = questions[_currentIndex];
    final isCorrect = _answered != null && _answered == question.answer;

    return Scaffold(
      backgroundColor: _answered == null
          ? Colors.white
          : isCorrect
              ? const Color(0xFFF0FDF4)
              : const Color(0xFFFEF2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Is it a Function?'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1}/${questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(questions.length, (index) {
                  Color color;
                  if (index < _currentIndex) {
                    color = const Color(0xFF10B981); // Completed
                  } else if (index == _currentIndex) {
                    color = AppTheme.primary; // Current
                  } else {
                    color = AppTheme.border; // Upcoming
                  }

                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Question card
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _answered == null
                        ? AppTheme.border
                        : isCorrect
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 48,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      question.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),

                    // Feedback
                    if (_answered != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCorrect ? 'Correct!' : 'Wrong! Answer: ${question.answer ? "YES" : "NO"}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              // YES / NO buttons
              Row(
                children: [
                  Expanded(
                    child: _buildAnswerButton(
                      label: 'NO',
                      color: const Color(0xFFEF4444),
                      isSelected: _answered == false,
                      onTap: () => _answer(false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAnswerButton(
                      label: 'YES',
                      color: const Color(0xFF10B981),
                      isSelected: _answered == true,
                      onTap: () => _answer(true),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _answered == null ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final passed = _score == questions.length;

    return Scaffold(
      backgroundColor: passed
          ? const Color(0xFFF0FDF4)
          : const Color(0xFFFEF2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                passed ? 'Perfect!' : 'Keep Trying!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: passed
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 12),

              // Score
              Text(
                'You got $_score out of ${questions.length} correct',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 8),

              if (!passed)
                Text(
                  'You need all correct to pass',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.muted,
                  ),
                ),

              const SizedBox(height: 48),

              // Stars display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(questions.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _score ? Icons.star : Icons.star_border,
                      color: const Color(0xFFF59E0B),
                      size: 36,
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Buttons
              if (!passed)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _score = 0;
                        _answered = null;
                        _showResult = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppTheme.primary),
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, passed);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: passed
                        ? const Color(0xFF10B981)
                        : AppTheme.primary,
                  ),
                  child: Text(passed ? 'Continue' : 'Go Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
