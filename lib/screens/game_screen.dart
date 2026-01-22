import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/learning_node.dart';
import '../data/learning_database.dart';

class GameScreen extends StatefulWidget {
  final LearningNode node;

  const GameScreen({super.key, required this.node});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _showResult = false;

  List<GameQuestion> get questions => widget.node.questions ?? [];

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.node.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: _buildGameContent(),
    );
  }

  Widget _buildGameContent() {
    final question = questions[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with progress and stars
          _buildHeader(),
          const SizedBox(height: 24),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 32),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFF59E0B),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return _buildOptionCard(index, question);
              },
            ),
          ),

          // Explanation
          if (_answered && question.explanation != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF93C5FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFF2563EB), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question.explanation!,
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Submit/Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAnswer == null ? null : () {
                if (_answered) {
                  _nextQuestion();
                } else {
                  _submitAnswer();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: Text(
                _answered
                    ? (_currentIndex < questions.length - 1 ? 'Next Question' : 'See Results')
                    : 'Submit Answer',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentIndex + 1} of ${questions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Need ${widget.node.requiredStars} stars to pass',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        // Current stars earned
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFCD34D)),
          ),
          child: Row(
            children: [
              ...List.generate(questions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    index < _score ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF59E0B),
                    size: 18,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(int index, GameQuestion question) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == question.correctIndex;

    Color bgColor = Colors.white;
    Color borderColor = AppTheme.border;
    Color textColor = AppTheme.text;

    if (_answered) {
      if (isCorrect) {
        bgColor = const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF10B981);
      } else if (isSelected) {
        bgColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFEF4444);
      }
    } else if (isSelected) {
      bgColor = const Color(0xFFFEF3C7);
      borderColor = const Color(0xFFF59E0B);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _answered ? null : () {
          setState(() => _selectedAnswer = index);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected || (_answered && isCorrect) ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFF59E0B)
                      : AppTheme.secondary,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFF59E0B)
                        : AppTheme.border,
                  ),
                ),
                child: Center(
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          String.fromCharCode(65 + index), // A, B, C...
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.muted,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
              if (_answered && isCorrect)
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24)
              else if (_answered && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAnswer() {
    setState(() {
      _answered = true;
      if (_selectedAnswer == questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    setState(() => _showResult = true);

    final passed = _score >= widget.node.requiredStars;

    if (passed) {
      await LearningDatabase.instance.completeNode(
        widget.node.id,
        stars: _score,
        score: ((_score / questions.length) * 100).round(),
      );
    } else {
      await LearningDatabase.instance.recordFailedAttempt(
        widget.node.id,
        stars: _score,
        score: ((_score / questions.length) * 100).round(),
      );
    }
  }

  Widget _buildResultScreen() {
    final passed = _score >= widget.node.requiredStars;

    return Scaffold(
      backgroundColor: passed
          ? const Color(0xFFFEFCE8)
          : const Color(0xFFFEF2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stars display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(questions.length, (index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 300 + (index * 150)),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: index < _score ? value : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            index < _score ? Icons.star : Icons.star_border,
                            color: const Color(0xFFF59E0B),
                            size: 48,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Result text
              Text(
                passed ? 'Amazing!' : 'Almost There!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: passed
                      ? const Color(0xFFB45309)
                      : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'You earned $_score out of ${questions.length} stars',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFF10B981).withAlpha(25)
                      : const Color(0xFFEF4444).withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passed
                      ? '✓ Requirement met (${widget.node.requiredStars} stars)'
                      : '✗ Need ${widget.node.requiredStars} stars to pass',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: passed
                        ? const Color(0xFF059669)
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),

              const Spacer(),

              // Buttons
              if (!passed)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _score = 0;
                        _selectedAnswer = null;
                        _answered = false;
                        _showResult = false;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: passed
                        ? const Color(0xFFF59E0B)
                        : AppTheme.primary,
                  ),
                  child: Text(
                    passed ? 'Continue' : 'Go Back',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Game?'),
        content: const Text('Your progress in this game will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
