import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/learning_node.dart';
import '../data/learning_content.dart';
import '../data/learning_database.dart';
import 'lesson_screen.dart';
import 'game_screen.dart';
import 'final_boss_screen.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  Map<String, NodeProgress> _progressMap = {};
  bool _isLoading = true;
  int _totalStars = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);

    final progress = await LearningDatabase.instance.getAllProgress();
    final totalStars = await LearningDatabase.instance.getTotalStars();

    setState(() {
      _progressMap = progress;
      _totalStars = totalStars;
      _isLoading = false;
    });
  }

  void _navigateToNode(LearningNode node, NodeProgress progress) {
    if (progress.status == NodeStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the previous lesson first!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Widget screen;
    switch (node.type) {
      case NodeType.lessonWithGame:
      case NodeType.lessonOnly:
      case NodeType.example:
        screen = LessonScreen(node: node);
        break;
      case NodeType.starGame:
        screen = GameScreen(node: node);
        break;
      case NodeType.finalBoss:
        screen = FinalBossScreen(node: node);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 20),
            SizedBox(width: 8),
            Text('MATH'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_totalStars',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLearningPath(),
    );
  }

  Widget _buildLearningPath() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Piecewise Functions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete each lesson to unlock the next',
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Progress indicator
          _buildProgressBar(),
          const SizedBox(height: 32),

          // Learning Path Timeline
          ...LearningContent.nodes.asMap().entries.map((entry) {
            final index = entry.key;
            final node = entry.value;
            final progress = _progressMap[node.id] ??
                NodeProgress(nodeId: node.id, status: NodeStatus.locked);
            final isLast = index == LearningContent.nodes.length - 1;

            return _buildTimelineNode(node, progress, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final completedCount = _progressMap.values
        .where((p) => p.status == NodeStatus.completed)
        .length;
    final total = LearningContent.nodes.length;
    final progress = total > 0 ? completedCount / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '$completedCount / $total',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? const Color(0xFF10B981) : AppTheme.primary,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(LearningNode node, NodeProgress progress, bool isLast) {
    final isBoss = node.type == NodeType.finalBoss;
    final isStarGame = node.type == NodeType.starGame;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 48,
            child: Column(
              children: [
                _buildNodeIndicator(progress.status, isBoss),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: progress.status == NodeStatus.completed
                          ? const Color(0xFF10B981)
                          : AppTheme.border,
                    ),
                  ),
              ],
            ),
          ),

          // Node card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: _buildNodeCard(node, progress, isBoss, isStarGame),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeIndicator(NodeStatus status, bool isBoss) {
    Color bgColor;
    Color borderColor;
    Widget icon;

    switch (status) {
      case NodeStatus.completed:
        bgColor = const Color(0xFF10B981);
        borderColor = const Color(0xFF10B981);
        icon = const Icon(Icons.check, color: Colors.white, size: 18);
        break;
      case NodeStatus.unlocked:
        bgColor = isBoss ? const Color(0xFFEF4444) : AppTheme.primary;
        borderColor = isBoss ? const Color(0xFFEF4444) : AppTheme.primary;
        icon = Icon(
          isBoss ? Icons.local_fire_department : Icons.play_arrow,
          color: Colors.white,
          size: 18,
        );
        break;
      case NodeStatus.locked:
        bgColor = Colors.white;
        borderColor = AppTheme.border;
        icon = Icon(Icons.lock, color: AppTheme.muted, size: 16);
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: icon),
    );
  }

  Widget _buildNodeCard(
    LearningNode node,
    NodeProgress progress,
    bool isBoss,
    bool isStarGame,
  ) {
    final isLocked = progress.status == NodeStatus.locked;
    final isCompleted = progress.status == NodeStatus.completed;

    return GestureDetector(
      onTap: () => _navigateToNode(node, progress),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? AppTheme.secondary
              : isBoss
                  ? (isCompleted ? const Color(0xFFFEF2F2) : const Color(0xFFFEE2E2))
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF10B981)
                : isBoss
                    ? const Color(0xFFEF4444)
                    : isLocked
                        ? AppTheme.border
                        : AppTheme.primary,
            width: isCompleted || (!isLocked && !isBoss) ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Node type badge
                      _buildTypeBadge(node.type, isBoss),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        node.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? AppTheme.muted : AppTheme.text,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        node.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right indicator
                if (isCompleted && isStarGame)
                  _buildStarsDisplay(progress.starsEarned)
                else if (isCompleted)
                  const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24)
                else if (isLocked)
                  Icon(Icons.lock_outline, color: AppTheme.muted, size: 20)
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isBoss ? const Color(0xFFEF4444) : AppTheme.primary,
                    size: 16,
                  ),
              ],
            ),

            // Stars requirement for star games
            if (isStarGame && !isCompleted && !isLocked) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Need ${node.requiredStars} stars to unlock next',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(NodeType type, bool isBoss) {
    String label;
    Color color;
    Color bgColor;

    switch (type) {
      case NodeType.lessonWithGame:
        label = 'LESSON + GAME';
        color = const Color(0xFF7C3AED);
        bgColor = const Color(0xFFF3E8FF);
        break;
      case NodeType.lessonOnly:
        label = 'LESSON';
        color = const Color(0xFF2563EB);
        bgColor = const Color(0xFFDBEAFE);
        break;
      case NodeType.example:
        label = 'EXAMPLE';
        color = const Color(0xFF0891B2);
        bgColor = const Color(0xFFCFFAFE);
        break;
      case NodeType.starGame:
        label = 'STAR GAME';
        color = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        break;
      case NodeType.finalBoss:
        label = 'FINAL BOSS';
        color = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEE2E2);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStarsDisplay(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: const Color(0xFFF59E0B),
          size: 18,
        );
      }),
    );
  }
}
