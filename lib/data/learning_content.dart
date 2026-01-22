import '../models/learning_node.dart';

/// All learning content data based on app_content.md
/// Linear learning path: 9 nodes total
class LearningContent {
  static const List<LearningNode> nodes = [
    // NODE 1: What is a Function? (Lesson + Yes/No Game)
    LearningNode(
      id: 'node_1',
      order: 1,
      title: 'What is a Function?',
      subtitle: 'Learn the basics + Play a game',
      type: NodeType.lessonWithGame,
      lessonContent: '''A function is a rule that assigns one output to each input. It shows how one variable depends on another.

Function models real-life problems by representing relationships between variables as equations.

**Key Points:**
• Input → independent variable (usually x)
• Output → dependent variable (usually y or f(x))

**Remember:** Each input must have exactly ONE output for it to be a function!''',
      yesNoQuestions: [
        YesNoQuestion(
          text: 'Each student is assigned one unique student number. Is this a function?',
          answer: true,
        ),
        YesNoQuestion(
          text: 'A person can have more than one email address. Is this a function?',
          answer: false,
        ),
        YesNoQuestion(
          text: 'Each day of the week has one assigned opening time for a store. Is this a function?',
          answer: true,
        ),
        YesNoQuestion(
          text: 'A phone number can belong to different people. Is this a function?',
          answer: false,
        ),
        YesNoQuestion(
          text: 'The number of hours worked determines exactly one salary amount. Is this a function?',
          answer: true,
        ),
      ],
    ),

    // NODE 2: Piecewise Functions (Lesson Only)
    LearningNode(
      id: 'node_2',
      order: 2,
      title: 'Piecewise Functions',
      subtitle: 'Multiple rules, one function',
      type: NodeType.lessonOnly,
      lessonContent: '''A piecewise function is a function defined by more than one equation, where each equation applies to a specific interval or condition.

**Think of it like:** A recipe with different instructions for different ingredients!

**Steps to Solve Piecewise Problems:**
1. Define your variables
2. Identify distinct scenarios (intervals)
3. Write a separate equation for each scenario
4. Combine into a single function f(x)

**Real-Life Examples:**
• Taxi fares that change after certain distances
• Delivery fees based on distance
• Phone plans with different rates''',
    ),

    // NODE 3: Example 1 - Grab Cab
    LearningNode(
      id: 'node_3',
      order: 3,
      title: 'Example 1: Grab Cab',
      subtitle: 'Step-by-step problem solving',
      type: NodeType.example,
      lessonContent: '''**Problem:**
Minimum fare is ₱80.00 for the first 4 km. If distance exceeds 4 km, base fare is ₱40.00 plus ₱10.00 per km.''',
      steps: [
        'Scenario 1 (0 < x ≤ 4):\nFare is fixed at ₱80\nf(x) = 80',
        'Scenario 2 (x > 4):\nBase fare ₱40 + ₱10 per km\nf(x) = 40 + 10x',
        'Final Piecewise Function:\nf(x) = { 80 if 0 < x ≤ 4\n       { 40 + 10x if x > 4',
      ],
      example: 'For 7 km: Since 7 > 4, use f(x) = 40 + 10(7) = 40 + 70 = ₱110',
      questions: [
        GameQuestion(
          text: 'What does x represent in this problem?',
          options: ['Passenger fare', 'Distance traveled', 'Base fare'],
          correctIndex: 1,
          explanation: 'x represents the distance traveled in kilometers.',
        ),
        GameQuestion(
          text: 'Which function applies when 0 < x ≤ 4?',
          options: ['40 + 10x', '10x', '80'],
          correctIndex: 2,
          explanation: 'For the first 4 km or less, the fare is fixed at ₱80.',
        ),
        GameQuestion(
          text: 'What is the fare for 2 km?',
          options: ['₱40', '₱60', '₱80'],
          correctIndex: 2,
          explanation: 'Since 2 ≤ 4, the fare is the minimum ₱80.',
        ),
        GameQuestion(
          text: 'Which formula applies when x > 4?',
          options: ['80', '10x', '40 + 10x'],
          correctIndex: 2,
          explanation: 'For distances beyond 4 km, use 40 + 10x.',
        ),
        GameQuestion(
          text: 'What is the fare for 7 km?',
          options: ['₱80', '₱110', '₱140'],
          correctIndex: 1,
          explanation: 'f(7) = 40 + 10(7) = 40 + 70 = ₱110',
        ),
      ],
    ),

    // NODE 4: Example 2 - Delivery Service
    LearningNode(
      id: 'node_4',
      order: 4,
      title: 'Example 2: Delivery Service',
      subtitle: 'Another real-world problem',
      type: NodeType.example,
      lessonContent: '''**Problem:**
Flat fee ₱50.00 within 3 km. If exceeds 3 km, fee is ₱20.00 plus ₱5.00 times the square of distance.''',
      steps: [
        'Scenario 1 (0 < x ≤ 3):\nFlat fee applies\nf(x) = 50',
        'Scenario 2 (x > 3):\nBase ₱20 + ₱5 times x²\nf(x) = 20 + 5x²',
        'Final Piecewise Function:\nf(x) = { 50 if 0 < x ≤ 3\n       { 20 + 5x² if x > 3',
      ],
      example: 'For 4 km: Since 4 > 3, use f(x) = 20 + 5(4)² = 20 + 5(16) = 20 + 80 = ₱100',
      questions: [
        GameQuestion(
          text: 'What does x represent?',
          options: ['Fee', 'Distance', 'Number of deliveries'],
          correctIndex: 1,
          explanation: 'x represents the distance in kilometers.',
        ),
        GameQuestion(
          text: 'What is the fee for 2 km?',
          options: ['₱20', '₱50', '₱70'],
          correctIndex: 1,
          explanation: 'Since 2 ≤ 3, the flat fee of ₱50 applies.',
        ),
        GameQuestion(
          text: 'Which formula applies when x > 3?',
          options: ['50', '20 + 5x', '20 + 5x²'],
          correctIndex: 2,
          explanation: 'For distances beyond 3 km, use 20 + 5x².',
        ),
        GameQuestion(
          text: 'What is the fee for exactly 3 km?',
          options: ['₱20', '₱35', '₱50'],
          correctIndex: 2,
          explanation: 'Since 3 ≤ 3, the flat fee of ₱50 still applies.',
        ),
        GameQuestion(
          text: 'Which is the correct piecewise function?',
          options: [
            '50 + 5x²',
            '{50 if x≤3; 20+5x² if x>3}',
            '{5x² if x≤3; 50 if x>3}'
          ],
          correctIndex: 1,
          explanation: 'The function has two pieces: flat ₱50 for short distances, and 20+5x² for longer ones.',
        ),
      ],
    ),

    // NODE 5: GAME 1 - Identifying the Interval
    LearningNode(
      id: 'node_5',
      order: 5,
      title: 'Game 1: Identify the Interval',
      subtitle: 'Which rule applies? ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Parking: ₱30 first hour, ₱20 after. Parked 0.5 hour. Which interval?',
          options: ['0 < x ≤ 1', 'x > 1'],
          correctIndex: 0,
          explanation: '0.5 hour is within the first hour, so 0 < x ≤ 1 applies.',
        ),
        GameQuestion(
          text: 'Bus: ₱25 first 2km, ₱10 after. Traveled 1 km. Which interval?',
          options: ['0 < x ≤ 2', 'x > 2'],
          correctIndex: 0,
          explanation: '1 km is within the first 2 km.',
        ),
        GameQuestion(
          text: 'Snack: ₱20 first item, ₱15 next two, ₱10 after. Bought 3 items. Category for 3rd item?',
          options: ['First item', 'Next two items'],
          correctIndex: 1,
          explanation: 'The 3rd item falls within "next two items" (items 2 and 3).',
        ),
        GameQuestion(
          text: 'Taxi: ₱60 first 5km, ₱15 after. Traveled 6 km. Which interval?',
          options: ['0 < x ≤ 5', 'x > 5'],
          correctIndex: 1,
          explanation: '6 km exceeds 5 km, so x > 5 applies.',
        ),
        GameQuestion(
          text: 'Parking: Free 1st hour, ₱50 for 2-3 hours, ₱80 above 3 hours. Parked 3.5 hours. Which interval?',
          options: ['2-3 hours', 'More than 3 hours'],
          correctIndex: 1,
          explanation: '3.5 hours exceeds 3 hours, so the "more than 3 hours" rate applies.',
        ),
      ],
    ),

    // NODE 6: GAME 2 - Choose the Formula
    LearningNode(
      id: 'node_6',
      order: 6,
      title: 'Game 2: Choose the Formula',
      subtitle: 'Pick the right equation ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Traveled 5km. Which formula?',
          options: ['50', '50 + 15(x-3)', '15x'],
          correctIndex: 1,
          explanation: 'For x > 3: Base ₱50 plus ₱15 for each km after 3.',
        ),
        GameQuestion(
          text: 'Parking: ₱30 first hour, ₱20 after. Parked 0.5 hour. Which formula?',
          options: ['30', '30 + 20(x-1)', '20x'],
          correctIndex: 0,
          explanation: 'Within first hour, flat rate of ₱30 applies.',
        ),
        GameQuestion(
          text: 'Delivery: ₱40 first 3km, ₱15 after. Traveled 5km. Which formula?',
          options: ['40', '15x', '40 + 15(x-3)'],
          correctIndex: 2,
          explanation: 'For x > 3: Base ₱40 plus ₱15 for each km after 3.',
        ),
        GameQuestion(
          text: 'Snack: ₱20 first item, ₱12 each additional. Bought 4 items. Which formula?',
          options: ['20', '12x', '20 + 12(x-1)'],
          correctIndex: 2,
          explanation: 'First item ₱20, then ₱12 for each additional (x-1) items.',
        ),
        GameQuestion(
          text: 'Subscription: ₱200 first 5 months, ₱180 after. Over 10 months gets 10% discount. For 12 months?',
          options: ['200 + 180(x-5)', '(200 + 180(x-5)) × 0.9', '200 + 180x'],
          correctIndex: 1,
          explanation: 'Calculate base cost, then apply 10% discount for >10 months.',
        ),
      ],
    ),

    // NODE 7: GAME 3 - Compute the Output
    LearningNode(
      id: 'node_7',
      order: 7,
      title: 'Game 3: Compute the Output',
      subtitle: 'Calculate the answer ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Traveled 4km. Total fare?',
          options: ['₱50', '₱65', '₱70'],
          correctIndex: 1,
          explanation: '50 + 15(4-3) = 50 + 15(1) = 50 + 15 = ₱65',
        ),
        GameQuestion(
          text: 'Bus: ₱25 first 2km, ₱10 after. Traveled 5km. Total fare?',
          options: ['₱45', '₱55', '₱50'],
          correctIndex: 1,
          explanation: '25 + 10(5-2) = 25 + 10(3) = 25 + 30 = ₱55',
        ),
        GameQuestion(
          text: 'Delivery: ₱40 first 3km, ₱15 after, +₱5 service fee. Traveled 5km. Total?',
          options: ['₱70', '₱75', '₱80'],
          correctIndex: 1,
          explanation: '40 + 15(5-3) + 5 = 40 + 30 + 5 = ₱75',
        ),
        GameQuestion(
          text: 'Subscription: ₱200 (5 mos), ₱180 after. >10 mos gets 10% off. Total for 12 months?',
          options: ['₱2034', '₱1980', '₱2220'],
          correctIndex: 0,
          explanation: '(200×5 + 180×7) × 0.9 = (1000 + 1260) × 0.9 = 2260 × 0.9 = ₱2034',
        ),
        GameQuestion(
          text: 'Electricity: Free 100kWh, ₱10/kWh next 50, ₱15/kWh above 150. Used 180 kWh. Total?',
          options: ['₱750', '₱950', '₱1050'],
          correctIndex: 1,
          explanation: '0 + 10×50 + 15×30 = 0 + 500 + 450 = ₱950',
        ),
      ],
    ),

    // NODE 8: GAME 4 - Match Inputs to Outputs
    LearningNode(
      id: 'node_8',
      order: 8,
      title: 'Game 4: Match the Values',
      subtitle: 'Input → Output ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      matchingContext: 'Taxi charges ₱50 for first 3 km, ₱15 per km after.',
      matchingItems: [
        MatchingItem(input: '2 km', output: '₱50'),
        MatchingItem(input: '3 km', output: '₱50'),
        MatchingItem(input: '4 km', output: '₱65'),
        MatchingItem(input: '6 km', output: '₱95'),
      ],
      questions: [
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Input: 2 km → Output?',
          options: ['₱50', '₱65', '₱80'],
          correctIndex: 0,
          explanation: '2 km ≤ 3 km, so flat rate ₱50 applies.',
        ),
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Input: 3 km → Output?',
          options: ['₱45', '₱50', '₱65'],
          correctIndex: 1,
          explanation: '3 km = 3 km boundary, flat rate ₱50 still applies.',
        ),
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Input: 4 km → Output?',
          options: ['₱50', '₱65', '₱80'],
          correctIndex: 1,
          explanation: '50 + 15(4-3) = 50 + 15 = ₱65',
        ),
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Input: 6 km → Output?',
          options: ['₱80', '₱95', '₱110'],
          correctIndex: 1,
          explanation: '50 + 15(6-3) = 50 + 45 = ₱95',
        ),
        GameQuestion(
          text: 'Taxi: ₱50 first 3km, ₱15 after. Input: 10 km → Output?',
          options: ['₱140', '₱155', '₱200'],
          correctIndex: 1,
          explanation: '50 + 15(10-3) = 50 + 105 = ₱155',
        ),
      ],
    ),

    // NODE 9: FINAL BOSS
    LearningNode(
      id: 'node_9',
      order: 9,
      title: 'FINAL BOSS',
      subtitle: 'Prove your mastery! 🔥',
      type: NodeType.finalBoss,
      passingScore: 70,
      questions: [
        GameQuestion(
          text: 'Which scenario is BEST represented by a piecewise function?',
          options: [
            'Distance traveled at constant speed',
            'Salary depending on hours worked',
            'Area of a circle'
          ],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'Parking: ₱20 first hour, ₱10 after. Why is this a piecewise function?',
          options: [
            'Fee is always the same',
            'Rule changes after 1st hour',
            'Cannot be graphed'
          ],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'What does the graph of a piecewise function look like?',
          options: [
            'A straight line',
            'A single curve',
            'Several lines/curves with different rules'
          ],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'Fare: ₱13 first 4km, ₱2 after. Which interval uses a DIFFERENT rule?',
          options: ['0-4 km', 'More than 4 km', 'Exactly 4 km'],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'In a piecewise function, each rule applies to a specific ___?',
          options: ['Value', 'Graph', 'Interval'],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'Which is a real-life example of a piecewise function?',
          options: [
            'Simple interest calculation',
            'Income tax brackets',
            'Area of a square'
          ],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'A cellphone plan changes rate after 5GB. What makes the function change?',
          options: ['Exactly 5GB', 'More than 5GB', 'Less than 5GB'],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'Delivery: ₱40 for ≤3km, different rate for >3km. For 5km, which rule?',
          options: ['₱40 flat rate', 'Base + rate × 5', 'Base + rate × (5-3)'],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'Why is income tax a piecewise function?',
          options: [
            'Fixed rate for everyone',
            'No income limits',
            'Different rates for different ranges'
          ],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'Taxi: ₱40 first 2km, ₱12 per km after. Fare for 6km?',
          options: ['₱72', '₱88', '₱96'],
          correctIndex: 1,
        ),
      ],
    ),
  ];

  /// Get node by ID
  static LearningNode? getNodeById(String id) {
    try {
      return nodes.firstWhere((node) => node.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get node by order
  static LearningNode? getNodeByOrder(int order) {
    try {
      return nodes.firstWhere((node) => node.order == order);
    } catch (_) {
      return null;
    }
  }

  /// Get next node
  static LearningNode? getNextNode(String currentId) {
    final current = getNodeById(currentId);
    if (current == null) return null;
    return getNodeByOrder(current.order + 1);
  }

  /// Get total nodes count
  static int get totalNodes => nodes.length;
}
