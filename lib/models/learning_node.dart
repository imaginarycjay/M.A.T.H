/// Represents the type of learning node in the path
enum NodeType {
  lessonWithGame,   // Node 1: Lesson + Yes/No game
  lessonOnly,       // Node 2: Read-only lesson
  example,          // Node 3, 4: Step-by-step example with quiz
  starGame,         // Node 5-8: Star games (need 4 stars to pass)
  finalBoss,        // Node 9: Final boss quiz
}

/// Represents the status of a node
enum NodeStatus {
  locked,
  unlocked,
  completed,
}

/// A single question in a game or quiz
class GameQuestion {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const GameQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'options': options,
    'correctIndex': correctIndex,
    'explanation': explanation,
  };

  factory GameQuestion.fromJson(Map<String, dynamic> json) => GameQuestion(
    text: json['text'],
    options: List<String>.from(json['options']),
    correctIndex: json['correctIndex'],
    explanation: json['explanation'],
  );
}

/// Yes/No question for Node 1 game
class YesNoQuestion {
  final String text;
  final bool answer;

  const YesNoQuestion({
    required this.text,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'answer': answer,
  };

  factory YesNoQuestion.fromJson(Map<String, dynamic> json) => YesNoQuestion(
    text: json['text'],
    answer: json['answer'],
  );
}

/// Matching question for Game 4
class MatchingItem {
  final String input;
  final String output;

  const MatchingItem({
    required this.input,
    required this.output,
  });

  Map<String, dynamic> toJson() => {
    'input': input,
    'output': output,
  };

  factory MatchingItem.fromJson(Map<String, dynamic> json) => MatchingItem(
    input: json['input'],
    output: json['output'],
  );
}

/// Represents a node in the linear learning path
class LearningNode {
  final String id;
  final int order;
  final String title;
  final String subtitle;
  final NodeType type;
  final String? lessonContent;
  final List<String>? steps; // For step-by-step examples
  final String? example;
  final List<YesNoQuestion>? yesNoQuestions;
  final List<GameQuestion>? questions;
  final List<MatchingItem>? matchingItems;
  final String? matchingContext;
  final int requiredStars; // For star games (default 4)
  final int passingScore; // For final boss (percentage)

  const LearningNode({
    required this.id,
    required this.order,
    required this.title,
    required this.subtitle,
    required this.type,
    this.lessonContent,
    this.steps,
    this.example,
    this.yesNoQuestions,
    this.questions,
    this.matchingItems,
    this.matchingContext,
    this.requiredStars = 4,
    this.passingScore = 70,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'order': order,
    'title': title,
    'subtitle': subtitle,
    'type': type.index,
    'lessonContent': lessonContent,
    'steps': steps,
    'example': example,
    'yesNoQuestions': yesNoQuestions?.map((q) => q.toJson()).toList(),
    'questions': questions?.map((q) => q.toJson()).toList(),
    'matchingItems': matchingItems?.map((m) => m.toJson()).toList(),
    'matchingContext': matchingContext,
    'requiredStars': requiredStars,
    'passingScore': passingScore,
  };

  factory LearningNode.fromJson(Map<String, dynamic> json) => LearningNode(
    id: json['id'],
    order: json['order'],
    title: json['title'],
    subtitle: json['subtitle'],
    type: NodeType.values[json['type']],
    lessonContent: json['lessonContent'],
    steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
    example: json['example'],
    yesNoQuestions: json['yesNoQuestions'] != null
        ? (json['yesNoQuestions'] as List).map((q) => YesNoQuestion.fromJson(q)).toList()
        : null,
    questions: json['questions'] != null
        ? (json['questions'] as List).map((q) => GameQuestion.fromJson(q)).toList()
        : null,
    matchingItems: json['matchingItems'] != null
        ? (json['matchingItems'] as List).map((m) => MatchingItem.fromJson(m)).toList()
        : null,
    matchingContext: json['matchingContext'],
    requiredStars: json['requiredStars'] ?? 4,
    passingScore: json['passingScore'] ?? 70,
  );
}

/// Progress for a single node
class NodeProgress {
  final String nodeId;
  final NodeStatus status;
  final int starsEarned;
  final int attempts;
  final int? lastScore;
  final DateTime? completedAt;

  const NodeProgress({
    required this.nodeId,
    required this.status,
    this.starsEarned = 0,
    this.attempts = 0,
    this.lastScore,
    this.completedAt,
  });

  NodeProgress copyWith({
    String? nodeId,
    NodeStatus? status,
    int? starsEarned,
    int? attempts,
    int? lastScore,
    DateTime? completedAt,
  }) => NodeProgress(
    nodeId: nodeId ?? this.nodeId,
    status: status ?? this.status,
    starsEarned: starsEarned ?? this.starsEarned,
    attempts: attempts ?? this.attempts,
    lastScore: lastScore ?? this.lastScore,
    completedAt: completedAt ?? this.completedAt,
  );

  Map<String, dynamic> toJson() => {
    'nodeId': nodeId,
    'status': status.index,
    'starsEarned': starsEarned,
    'attempts': attempts,
    'lastScore': lastScore,
    'completedAt': completedAt?.millisecondsSinceEpoch,
  };

  factory NodeProgress.fromJson(Map<String, dynamic> json) => NodeProgress(
    nodeId: json['nodeId'] ?? json['node_id'],
    status: NodeStatus.values[json['status']],
    starsEarned: json['starsEarned'] ?? json['stars_earned'] ?? 0,
    attempts: json['attempts'] ?? 0,
    lastScore: json['lastScore'] ?? json['last_score'],
    completedAt: json['completedAt'] != null || json['completed_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'] ?? json['completed_at'])
        : null,
  );
}
