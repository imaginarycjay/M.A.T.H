import '../models/learning_node.dart';

/// All learning content data based on updated_content.md
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
• **Input:** independent variable (usually x)
• **Output:** dependent variable (usually y or f(x))
• **Remember:** Each input must have exactly ONE output for it to be a function!

**Example:**
If a number of hours worked affects salary, then salary depends on hours worked.

**Analysis:** Since the salary depends on hours worked, we assume that **x (independent variable) = hours worked**, and **y (dependent variable) = salary**.''',
      yesNoQuestions: [
        YesNoQuestion(
          text: 'Each student is assigned one unique student number.',
          answer: true,
          explanation: 'Each input (student) has exactly one output (student number).',
        ),
        YesNoQuestion(
          text: 'A person can have more than one email address.',
          answer: false,
          explanation: 'This means the input (person) does not just have one output (email).',
        ),
        YesNoQuestion(
          text: 'Each day of the week has one assigned opening time for a store.',
          answer: true,
          explanation: 'Each input (day) has exactly one output (opening time).',
        ),
        YesNoQuestion(
          text: 'A phone number can belong to different people.',
          answer: false,
          explanation: 'This means the phone number (input) can give different outputs (people).',
        ),
        YesNoQuestion(
          text: 'The number of hours worked determines exactly one salary amount.',
          answer: true,
          explanation: 'Each input (hours) has exactly one output (salary).',
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
      lessonContent: '''**Multiple rules, one function.**

A piecewise function is a function defined by more than one equation, where each equation applies to a specific interval or condition.

**Think of it like:** A recipe with different instructions for different ingredients!

**Steps in Solving a Piecewise Function:**
1. Define variables.
2. Identify the distinct scenarios (intervals).
3. Write an equation for each scenario.
4. Substitute the given values into a piecewise function.
5. Solve.

**Real-Life Examples:**
• Taxi fares that change after certain distances.
• Delivery fees based on distance.
• Phone plans with different rates.''',
    ),

    // NODE 3: Example 1 - Grab Cab
    LearningNode(
      id: 'node_3',
      order: 3,
      title: 'Example 1: Grab Cab',
      subtitle: 'Step-by-step problem solving',
      type: NodeType.example,
      lessonContent: '''**Problem:**
The minimum fare for a regular grab cab is Php 80.00 for the first 4 km. If the distance exceeds 4 km, the base fare is Php 40.00 plus Php 10.00 for every kilometer. Construct a function that would represent the fare of the passenger given the distance travelled.''',
      steps: [
        r'''**Step 1: Define Variables**
• Let $x$ = distance traveled (Input)
• Let $f(x)$ = fare of the passenger (Output)''',
        r'''**Step 2: Identify Scenarios**
• Scenario 1: If $0 < x \le 4$, Fare is fixed at Php 80.00.
• Scenario 2: If $x > 4$, Base fare is Php 40 plus Php 10 for every km.''',
        r'''**Step 3: Write Equations**
• Scenario 1: $f(x) = 80$
• Scenario 2: $f(x) = 40 + 10x$''',
        r'''**Step 4: Final Piecewise Function**
$$f(x) = \begin{cases} 80 & \text{if } 0 < x \le 4 \\ 40 + 10x & \text{if } x > 4 \end{cases}$$''',
      ],
      example: r'''Example 1: If distance (x) is 3 km
Since $0 < 3 \le 4$, use the first equation:
$f(x) = 80,\ 0 < x \le 4$
$f(3) = 80$
Fare of the passenger = Php 80
Explanation: This means that for 3 km traveled, the fare of the passenger is a fixed amount of Php 80.

Example 2: If distance (x) is 6 km
Since $6 > 4$, use the second equation:
$f(x) = 40 + 10x,\ x > 4$
$f(6) = 40 + 10(6)$
$f(6) = 40 + 60$
$f(6) = 100$
Fare of the passenger = Php 100
Explanation: This means that for 6 km traveled, exceeding 4 km, the passenger pays Php 40 and is charged an additional Php 10 for every km beyond 4 km, making the passenger fare fixed at Php 100.''',
      questions: [
        GameQuestion(
          text: 'What does x represent based on the first example?',
          options: ['Passenger fare', 'Distance traveled', 'Base fare'],
          correctIndex: 1,
          explanation: 'x represents the distance traveled in kilometers.',
        ),
        GameQuestion(
          text: 'Which function correctly represents the fare for distances 0 < x ≤ 4?',
          options: ['f(x) = 40 + 10x', 'f(x) = 10x', 'f(x) = 80'],
          correctIndex: 2,
          explanation: 'For the first 4 km or less, the fare is fixed at Php 80.',
        ),
        GameQuestion(
          text: 'If a passenger travels 2 km, how much is the fare?',
          options: ['Php 40', 'Php 60', 'Php 80'],
          correctIndex: 2,
          explanation: 'Since 2 km ≤ 4 km, the fare is the fixed Php 80.',
        ),
        GameQuestion(
          text: 'Which formula should be used if the distance traveled is more than 4 km?',
          options: ['f(x) = 80', 'f(x) = 10x', 'f(x) = 40 + 10x'],
          correctIndex: 2,
          explanation: 'For distances beyond 4 km, use f(x) = 40 + 10x.',
        ),
        GameQuestion(
          text: 'What is the fare if the passenger travels 7 km?',
          options: ['Php 80', 'Php 110', 'Php 140'],
          correctIndex: 1,
          explanation: 'Solution: 40 + 10(7) = 40 + 70 = Php 110',
        ),
      ],
    ),

    // NODE 4: Example 2 - Delivery Service
    // NOTE: Values updated from 3km to 5km per revision
    LearningNode(
      id: 'node_4',
      order: 4,
      title: 'Example 2: Delivery Service',
      subtitle: 'Another real-world problem',
      type: NodeType.example,
      lessonContent: '''**Problem:**
A delivery service charges a flat fee of Php 50.00 for deliveries within 5 kilometers. If the distance exceeds 5 kilometers, the delivery fee is Php 20.00 plus Php 5.00 times the square of the distance traveled. Construct a function that represents the delivery fee based on distance.''',
      steps: [
        r'''**Step 1: Define Variables**
• Let $x$ = distance traveled
• Let $f(x)$ = delivery fee''',
        r'''**Step 2: Identify Scenarios**
• Scenario 1: If $0 < x \le 5$, Fee is fixed at Php 50.00.
• Scenario 2: If $x > 5$, Base Php 20 + Php 5 multiplied by $x^2$.''',
        r'''**Step 3: Write Equations**
• Scenario 1: $f(x) = 50$
• Scenario 2: $f(x) = 20 + 5x^2$''',
        r'''**Step 4: Final Piecewise Function**
$$f(x) = \begin{cases} 50 & \text{if } 0 < x \le 5 \\ 20 + 5x^2 & \text{if } x > 5 \end{cases}$$''',
      ],
      example: r'''Example 1: If distance (x) is 4 km
Since $0 < 4 \le 5$, use the first equation:
$f(x) = 50,\ 0 < x \le 5$
$f(4) = 50$
Delivery fee = Php 50
Explanation: This means that the fee for traveling 4 km is Php 50.

Example 2: If distance (x) is 7 km
Since $7 > 5$, use the second equation:
$f(x) = 20 + 5x^2,\ x > 5$
$f(7) = 20 + 5(7)^2$
$f(7) = 20 + 5(49)$
$f(7) = 20 + 245$
$f(7) = 265$
Delivery fee = Php 265
Explanation: This means that the fee for traveling 7 km is Php 265''',
      questions: [
        GameQuestion(
          text: 'What does x represent in this problem?',
          options: ['Delivery fee', 'Distance traveled', 'Number of deliveries'],
          correctIndex: 1,
          explanation: 'x represents the distance traveled in kilometers.',
        ),
        GameQuestion(
          text: 'What is the delivery fee if the distance is 2 km?',
          options: ['Php 20', 'Php 50', 'Php 70'],
          correctIndex: 1,
          explanation: 'Within 5km range, the flat fee of Php 50 applies.',
        ),
        GameQuestion(
          text: 'Which formula applies when x > 5?',
          options: ['50', '20 + 5x', '20 + 5x²'],
          correctIndex: 2,
          explanation: 'For distances beyond 5 km, use 20 + 5x².',
        ),
        GameQuestion(
          text: 'If the distance is 7 km, what is the delivery fee?',
          options: ['Php 245', 'Php 265', 'Php 300'],
          correctIndex: 1,
          explanation: 'Solution: 20 + 5(49) = 20 + 245 = Php 265',
        ),
        GameQuestion(
          text: 'Which is the correct piecewise function?',
          options: [
            '50 + 5x²',
            '{50 if x≤5; 20+5x² if x>5}',
            '{5x² if x≤5; 50 if x>5}'
          ],
          correctIndex: 1,
          explanation: 'The function has two pieces: flat Php 50 for distances within 5km, and 20+5x² for longer distances.',
        ),
      ],
    ),

    // NODE 5: GAME 1 - Identifying the Interval
    // Requirement: 4/5 Stars to Unlock Next Node
    LearningNode(
      id: 'node_5',
      order: 5,
      title: 'Game 1: Identify the Interval',
      subtitle: 'Which rule applies? ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Parking Php 30 (1st hr), Php 20 after. Parked 0.5 hr. Interval?',
          options: ['0 < x ≤ 1', 'x > 1'],
          correctIndex: 0,
          explanation: '0.5 hour is within the first hour, so 0 < x ≤ 1 applies.',
        ),
        GameQuestion(
          text: 'Bus Php 25 (first 2km), Php 10 after. Traveled 1 km. Interval?',
          options: ['0 < x ≤ 2', 'x > 2'],
          correctIndex: 0,
          explanation: '1 km is within the first 2 km.',
        ),
        GameQuestion(
          text: 'Snack Php 20 (1st item), Php 15 (next 2), Php 10 after. Bought 3 items. Category for 3rd item?',
          options: ['First item', 'Next two items'],
          correctIndex: 1,
          explanation: 'The 3rd item falls within "next two items" (items 2 and 3).',
        ),
        GameQuestion(
          text: 'Taxi Php 60 (first 5km), Php 15 after. Traveled 6 km. Interval?',
          options: ['0 < x ≤ 5', 'x > 5'],
          correctIndex: 1,
          explanation: '6 km exceeds 5 km, so x > 5 applies.',
        ),
        GameQuestion(
          text: 'Parking Free (1st hr), Php 50 (2-3 hrs), Php 80 (>3 hrs). Parked 3.5 hrs. Interval?',
          options: ['2-3 hours', 'More than 3 hours'],
          correctIndex: 1,
          explanation: '3.5 hours exceeds 3 hours, so the "more than 3 hours" rate applies.',
        ),
      ],
    ),

    // NODE 6: GAME 2 - Choose the Formula
    // Requirement: 4/5 Stars to Unlock Next Node
    LearningNode(
      id: 'node_6',
      order: 6,
      title: 'Game 2: Choose the Formula',
      subtitle: 'Pick the right equation ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Taxi Php 50 (first 3km), Php 15 after. Traveled 5km. Which formula?',
          options: ['50', r'$50 + 15(x-3)$', r'$15x$'],
          correctIndex: 1,
          explanation: r'For $x > 3$: Base Php 50 plus Php 15 for each km after 3.',
        ),
        GameQuestion(
          text: 'Parking Php 30 (1st hr), Php 20 after. Parked 0.5 hr. Which formula?',
          options: ['30', r'$30 + 20(x-1)$', r'$20x$'],
          correctIndex: 0,
          explanation: 'Within first hour, flat rate of Php 30 applies.',
        ),
        GameQuestion(
          text: 'Delivery Php 40 (first 3km), Php 15 after. Traveled 5km. Which formula?',
          options: ['40', r'$15x$', r'$40 + 15(x-3)$'],
          correctIndex: 2,
          explanation: r'For $x > 3$: Base Php 40 plus Php 15 for each km after 3.',
        ),
        GameQuestion(
          text: 'Snack Php 20 (1st item), Php 12 additional. Bought 4 items. Which formula?',
          options: ['20', r'$12x$', r'$20 + 12(x-1)$'],
          correctIndex: 2,
          explanation: r'First item Php 20, then Php 12 for each additional $(x-1)$ items.',
        ),
        GameQuestion(
          text: 'Subscription 200 (first 5 mos), 180 after. >10 mos gets 10% discount. 12 months total. Which formula?',
          options: [r'$200 + 180(x-5)$', r'$(200 + 180(x-5)) \times 0.9$', r'$200 + 180x$'],
          correctIndex: 1,
          explanation: 'Calculate base cost, then apply 10% discount for >10 months.',
        ),
      ],
    ),

    // NODE 7: GAME 3 - Compute the Output
    // Requirement: 4/5 Stars to Unlock Next Node
    LearningNode(
      id: 'node_7',
      order: 7,
      title: 'Game 3: Compute the Output',
      subtitle: 'Calculate the answer ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      questions: [
        GameQuestion(
          text: 'Taxi 50 (first 3km), 15 after. Traveled 4km. Total fare?',
          options: ['50', '65', '70'],
          correctIndex: 1,
          explanation: r'$50 + 15(4-3) = 50 + 15(1) = 50 + 15 = 65$',
        ),
        GameQuestion(
          text: 'Bus 25 (first 2km), 10 after. Traveled 5km. Total fare?',
          options: ['45', '55', '50'],
          correctIndex: 1,
          explanation: r'$25 + 10(5-2) = 25 + 10(3) = 25 + 30 = 55$',
        ),
        GameQuestion(
          text: 'Delivery 40 (first 3km), 15 after, +5 service fee. Traveled 5km. Total?',
          options: ['70', '75', '80'],
          correctIndex: 1,
          explanation: r'$40 + 15(5-3) + 5 = 40 + 30 + 5 = 75$',
        ),
        GameQuestion(
          text: 'Subscription 200 (5 mos), 180 after. >10 mos 10% discount. Total for 12 mos?',
          options: ['2034', '1980', '2220'],
          correctIndex: 0,
          explanation: r'$(200 \times 5 + 180 \times 7) \times 0.9 = (1000 + 1260) \times 0.9 = 2260 \times 0.9 = 2034$',
        ),
        GameQuestion(
          text: 'Electricity Free 100kWh, 10/kWh next 50, 15/kWh above 150. Used 180 kWh. Total?',
          options: ['750', '950', '1050'],
          correctIndex: 1,
          explanation: r'$0 + 10 \times 50 + 15 \times 30 = 0 + 500 + 450 = 950$',
        ),
      ],
    ),

    // NODE 8: GAME 4 - Match Inputs to Outputs
    // Requirement: 4/5 Stars to Unlock Next Node
    // Scenario: Taxi charges Php 50 for first 3 km, Php 15 per km after.
    LearningNode(
      id: 'node_8',
      order: 8,
      title: 'Game 4: Match the Values',
      subtitle: 'Input → Output ⭐',
      type: NodeType.starGame,
      requiredStars: 4,
      matchingContext: 'Taxi charges Php 50 for first 3 km, Php 15 per km after.',
      matchingItems: [
        MatchingItem(input: '2 km', output: 'Php 50'),
        MatchingItem(input: '3 km', output: 'Php 50'),
        MatchingItem(input: '4 km', output: 'Php 65'),
        MatchingItem(input: '6 km', output: 'Php 95'),
      ],
      questions: [
        GameQuestion(
          text: 'Taxi: Php 50 first 3km, Php 15 after. Input: 2 km → Output?',
          options: ['Php 50', 'Php 65', 'Php 80'],
          correctIndex: 0,
          explanation: r'$2 \text{ km} \le 3 \text{ km}$, so flat rate Php 50 applies.',
        ),
        GameQuestion(
          text: 'Taxi: Php 50 first 3km, Php 15 after. Input: 3 km → Output?',
          options: ['Php 45', 'Php 50', 'Php 65'],
          correctIndex: 1,
          explanation: r'$3 \text{ km} = 3 \text{ km}$ boundary, flat rate Php 50 still applies.',
        ),
        GameQuestion(
          text: 'Taxi: Php 50 first 3km, Php 15 after. Input: 4 km → Output?',
          options: ['Php 50', 'Php 65', 'Php 80'],
          correctIndex: 1,
          explanation: r'$50 + 15(4-3) = 50 + 15 = \text{Php } 65$',
        ),
        GameQuestion(
          text: 'Taxi: Php 50 first 3km, Php 15 after. Input: 6 km → Output?',
          options: ['Php 80', 'Php 95', 'Php 110'],
          correctIndex: 1,
          explanation: r'$50 + 15(6-3) = 50 + 45 = \text{Php } 95$',
        ),
        GameQuestion(
          text: 'Taxi: Php 50 first 3km, Php 15 after. Input: 10 km → Output?',
          options: ['Php 140', 'Php 155', 'Php 200'],
          correctIndex: 1,
          explanation: r'$50 + 15(10-3) = 50 + 105 = \text{Php } 155$',
        ),
      ],
    ),

    // NODE 9: FINAL BOSS (General Knowledge)
    // Theme: Red/Dark. No Hints.
    // Ratio: 60% Easy, 30% Average, 10% Difficult
    LearningNode(
      id: 'node_9',
      order: 9,
      title: 'FINAL BOSS',
      subtitle: 'Prove your mastery! 🔥',
      type: NodeType.finalBoss,
      passingScore: 70,
      questions: [
        // EASY Questions (60% = 6 questions)
        GameQuestion(
          text: 'What is a piecewise function?',
          options: [
            'A function with no graph',
            'A function with only one rule',
            'A function with only linear equation',
            'A function defined by different rules for different intervals'
          ],
          correctIndex: 3,
        ),
        GameQuestion(
          text: 'Which symbol is commonly used to show the conditions in a piecewise function?',
          options: [
            'Absolute value | |',
            'Bracket []',
            'Curly braces {}',
            'Parentheses ()'
          ],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'In a piecewise function, what determines which rule to use?',
          options: [
            'The slope',
            'The y-intercept',
            'The output value',
            'The given condition or interval of x'
          ],
          correctIndex: 3,
        ),
        GameQuestion(
          text: r'What does the condition $0 < x \le 10$ mean?',
          options: [
            'x is less than 10',
            'x is equal to 0 and 10',
            'x is greater than 10 only',
            'x is greater than 0 but is less than or equal to 10'
          ],
          correctIndex: 3,
        ),
        GameQuestion(
          text: 'Which of the following conditions includes the number 3?',
          options: [
            r'$x < 3$',
            r'$x > 3$',
            r'$x \le 3$',
            r'$x \ne 3$'
          ],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'Piecewise functions are commonly used to model situations that have:',
          options: [
            'no rules',
            'changing rules',
            'only one formula',
            'imaginary numbers'
          ],
          correctIndex: 1,
        ),
        // AVERAGE Questions (30% = 3 questions)
        GameQuestion(
          text: 'A school implements a grading policy where students who score below 80 follow one computation rule, while those who score 80 and above follow a different computation rule. Which computation rule applies to a student who scored 85?',
          options: [
            'The rule for scores equal to 80 only',
            'The rule for scores 80 and above',
            'The rule for scores below 80',
            'No computation rule applies'
          ],
          correctIndex: 1,
        ),
        GameQuestion(
          text: 'A printing shop charges 5 per page for the first 20 pages. Any page beyond 20 costs 3 per page. How much will a customer pay for 30 pages?',
          options: [
            'P110',
            'P120',
            'P130',
            'P150'
          ],
          correctIndex: 2,
        ),
        GameQuestion(
          text: 'A taxi charges a base fare of P50 for the first 2 kilometers. After that, an additional P15 is charged per kilometer. How much is the fare for a 5-kilometer ride?',
          options: [
            'P95',
            'P110',
            'P125',
            'P140'
          ],
          correctIndex: 0,
        ),
        // DIFFICULT Question (10% = 1 question)
        GameQuestion(
          text: 'A delivery service uses one pricing rule for distances less than 10 km and another rule for distances greater than or equal to 10 km. How would you BEST represent and explain this situation mathematically?',
          options: [
            'By using a single linear equation',
            'By creating a table of values only',
            'By defining a piecewise function with distance intervals',
            'By using a constant function'
          ],
          correctIndex: 2,
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
