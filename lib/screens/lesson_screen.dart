import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/learning_node.dart';
import '../data/learning_database.dart';
import 'yes_no_game_screen.dart';

class LessonScreen extends StatefulWidget {
  final LearningNode node;

  const LessonScreen({super.key, required this.node});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentStep = 0;
  bool _showQuiz = false;
  int _quizIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.node.title.split(':').first),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _showQuiz
          ? _buildQuizView()
          : _buildLessonView(),
    );
  }

  Widget _buildLessonView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Content Card
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getNodeIcon(),
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.node.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.node.subtitle,
                              style: TextStyle(
                                color: AppTheme.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(),
                ),
              ],
            ),
          ),

          // Steps for example type
          if (widget.node.type == NodeType.example && widget.node.steps != null)
            _buildStepsSection(),

          // Example box
          if (widget.node.example != null)
            _buildExampleBox(),

          // Action button
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildActionButton(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final content = widget.node.lessonContent ?? '';
    final lines = content.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('**') && line.endsWith('**') && line.indexOf('**', 2) == line.length - 2) {
          // Bold header (full line bold)
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              line.replaceAll('**', ''),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          );
        } else if (line.startsWith('• ')) {
          // Bullet point with potential inline formatting
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: _buildRichText(line.substring(2)),
                ),
              ],
            ),
          );
        } else if (line.isEmpty) {
          return const SizedBox(height: 8);
        } else {
          // Regular text with potential inline formatting
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRichText(line),
          );
        }
      }).toList(),
    );
  }

  Widget _buildRichText(String text, {bool isActive = true}) {
    List<TextSpan> spans = [];
    RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    final baseColor = isActive ? AppTheme.text : AppTheme.muted;

    for (Match match in boldRegex.allMatches(text)) {
      // Add text before bold part
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: baseColor,
          ),
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
      ));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: baseColor,
        ),
      ));
    }

    // If no bold formatting found, return simple text
    if (spans.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: baseColor,
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildStepsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step-by-Step Solution',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.node.steps!.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isActive = index <= _currentStep;

            return GestureDetector(
              onTap: () {
                if (index <= _currentStep + 1) {
                  setState(() => _currentStep = index);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : AppTheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? AppTheme.primary : AppTheme.border,
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.primary : AppTheme.border,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppTheme.muted,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRichText(step, isActive: isActive),
                    ),
                  ],
                ),
              ),
            );
          }),

          if (_currentStep < (widget.node.steps?.length ?? 1) - 1)
            TextButton.icon(
              onPressed: () {
                setState(() => _currentStep++);
              },
              icon: const Icon(Icons.arrow_downward, size: 16),
              label: const Text('Show Next Step'),
            ),
        ],
      ),
    );
  }

  Widget _buildExampleBox() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: const Color(0xFF16A34A),
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Example',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRichText(widget.node.example!),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final hasGame = widget.node.type == NodeType.lessonWithGame;
    final hasQuiz = widget.node.type == NodeType.example &&
                    widget.node.questions != null;
    final isStepsComplete = widget.node.steps == null ||
                            _currentStep >= (widget.node.steps!.length - 1);

    if (hasGame) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => YesNoGameScreen(node: widget.node),
              ),
            );
            if (result == true && mounted) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.sports_esports),
          label: const Text('Play the Game'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    if (hasQuiz && isStepsComplete) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() => _showQuiz = true);
          },
          icon: const Icon(Icons.quiz),
          label: const Text('Try This Quiz'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    // Lesson only - just mark as read
    if (widget.node.type == NodeType.lessonOnly) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            await LearningDatabase.instance.completeNode(widget.node.id);
            if (mounted) {
              _showCompletionDialog();
            }
          },
          icon: const Icon(Icons.check),
          label: const Text('I understand, Continue'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // Quiz view for example nodes
  Widget _buildQuizView() {
    final questions = widget.node.questions!;
    final question = questions[_quizIndex];

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
                'Question ${_quizIndex + 1} of ${questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score: $_score',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_quizIndex + 1) / questions.length,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 24),

          // Question
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == index;
            final isCorrect = index == question.correctIndex;

            Color bgColor = Colors.white;
            Color borderColor = AppTheme.border;

            if (_answered) {
              if (isCorrect) {
                bgColor = const Color(0xFFF0FDF4);
                borderColor = const Color(0xFF10B981);
              } else if (isSelected) {
                bgColor = const Color(0xFFFEF2F2);
                borderColor = const Color(0xFFEF4444);
              }
            } else if (isSelected) {
              borderColor = AppTheme.primary;
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
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          color: isSelected ? AppTheme.primary : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      if (_answered && isCorrect)
                        const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Explanation
          if (_answered && question.explanation != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF93C5FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 20),
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
          ],

          const Spacer(),

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
              ),
              child: Text(_answered
                  ? (_quizIndex < questions.length - 1 ? 'Next' : 'Finish')
                  : 'Check Answer'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAnswer() {
    setState(() {
      _answered = true;
      if (_selectedAnswer == widget.node.questions![_quizIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    final questions = widget.node.questions!;

    if (_quizIndex < questions.length - 1) {
      setState(() {
        _quizIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final total = widget.node.questions!.length;
    final passed = _score >= (total * 0.6); // 60% to pass

    if (passed) {
      await LearningDatabase.instance.completeNode(
        widget.node.id,
        score: ((_score / total) * 100).round(),
      );
      if (mounted) {
        _showCompletionDialog();
      }
    } else {
      if (mounted) {
        _showRetryDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Text('Great Job!'),
          ],
        ),
        content: const Text('You\'ve completed this lesson. Keep going!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.replay, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Try Again'),
          ],
        ),
        content: Text('You scored $_score/${widget.node.questions!.length}. You need at least 60% to pass.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _quizIndex = 0;
                _selectedAnswer = null;
                _answered = false;
                _score = 0;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  IconData _getNodeIcon() {
    switch (widget.node.type) {
      case NodeType.lessonWithGame:
        return Icons.school;
      case NodeType.lessonOnly:
        return Icons.menu_book;
      case NodeType.example:
        return Icons.calculate;
      case NodeType.starGame:
        return Icons.star;
      case NodeType.finalBoss:
        return Icons.local_fire_department;
    }
  }
}
