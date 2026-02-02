import 'package:flutter/material.dart';
import '../models/learning_node.dart';
import '../data/learning_database.dart';
import '../widgets/math_renderer.dart';
import '../utils/sound_manager.dart';

class FinalBossScreen extends StatefulWidget {
  final LearningNode node;

  const FinalBossScreen({super.key, required this.node});

  @override
  State<FinalBossScreen> createState() => _FinalBossScreenState();
}

class _FinalBossScreenState extends State<FinalBossScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _showResult = false;
  bool _started = false;

  List<GameQuestion> get questions => widget.node.questions ?? [];

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    if (!_started) {
      return _buildIntroScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            const Text('FINAL BOSS'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: _buildQuizContent(),
    );
  }

  Widget _buildIntroScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Boss icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withAlpha(127),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'FINAL BOSS',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'General Knowledge Test',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 40),

              // Rules
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF404040)),
                ),
                child: Column(
                  children: [
                    _buildRuleItem(Icons.quiz, '${questions.length} Questions'),
                    const SizedBox(height: 12),
                    _buildRuleItem(Icons.percent, '${widget.node.passingScore}% to Pass'),
                    const SizedBox(height: 12),
                    _buildRuleItem(
                      Icons.block,
                      'NO HINTS ALLOWED',
                      isWarning: true,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _started = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'BEGIN CHALLENGE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Not Ready Yet',
                  style: TextStyle(color: Color(0xFF9CA3AF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String text, {bool isWarning = false}) {
    return Row(
      children: [
        Icon(
          icon,
          color: isWarning ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF),
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isWarning ? const Color(0xFFEF4444) : Colors.white,
            fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizContent() {
    final question = questions[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1}/${questions.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score: $_score',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              backgroundColor: const Color(0xFF404040),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF404040)),
            ),
            child: MathRenderer(
              text: question.text,
              fontSize: 18,
              textColor: Colors.white,
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

          // Submit button
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
                backgroundColor: const Color(0xFFEF4444),
                disabledBackgroundColor: const Color(0xFF404040),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _answered
                    ? (_currentIndex < questions.length - 1 ? 'Next' : 'Finish')
                    : 'Submit',
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

  Widget _buildOptionCard(int index, GameQuestion question) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == question.correctIndex;

    Color bgColor = const Color(0xFF2D2D2D);
    Color borderColor = const Color(0xFF404040);

    if (_answered) {
      if (isCorrect) {
        bgColor = const Color(0xFF10B981).withAlpha(51);
        borderColor = const Color(0xFF10B981);
      } else if (isSelected) {
        bgColor = const Color(0xFFEF4444).withAlpha(51);
        borderColor = const Color(0xFFEF4444);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFFF59E0B);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _answered ? null : () {
          SoundManager.instance.playClick();
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
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF404040),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MathRenderer(
                  text: question.options[index],
                  fontSize: 15,
                  textColor: Colors.white,
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
    final isCorrect = _selectedAnswer == questions[_currentIndex].correctIndex;

    // Play appropriate sound
    if (isCorrect) {
      SoundManager.instance.playCorrect();
    } else {
      SoundManager.instance.playWrong();
    }

    setState(() {
      _answered = true;
      if (isCorrect) {
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
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() => _showResult = true);

    final percentage = (_score / questions.length) * 100;
    final passed = percentage >= widget.node.passingScore;

    // Play level complete sound if passed
    if (passed) {
      SoundManager.instance.playLevelComplete();
    }

    if (passed) {
      await LearningDatabase.instance.completeNode(
        widget.node.id,
        score: percentage.round(),
      );
    } else {
      await LearningDatabase.instance.recordFailedAttempt(
        widget.node.id,
        score: percentage.round(),
      );
    }
  }

  Widget _buildResultScreen() {
    final percentage = (_score / questions.length) * 100;
    final passed = percentage >= widget.node.passingScore;

    return Scaffold(
      backgroundColor: passed
          ? const Color(0xFF1F1F1F)
          : const Color(0xFF1F1F1F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (passed
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444)).withAlpha(127),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  passed ? Icons.emoji_events : Icons.replay,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              Text(
                passed ? 'VICTORY!' : 'GAME OVER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: passed
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 16),

              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${percentage.round()}%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_score / ${questions.length} correct',
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                passed
                    ? 'Congratulations! You\'ve mastered Piecewise Functions!'
                    : 'You need ${widget.node.passingScore}% to pass. Keep practicing!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
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
                        _started = false;
                      });
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF404040)),
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
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                  child: Text(
                    passed ? 'Complete Journey' : 'Go Back',
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
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Boss Fight?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your progress will be lost and you\'ll have to start over.',
          style: TextStyle(color: Color(0xFF9CA3AF)),
        ),
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
