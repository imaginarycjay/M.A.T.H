import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/topic.dart';
import '../models/question.dart';
import '../widgets/text_span_builder.dart';

final List<Module> appModules = [
  Module(
    id: 'M1',
    title: 'Module 1: Key Concept of Functions',
    description: 'Representation, Evaluation, Operations, and Problem Solving.',
    topics: [
      Topic(
        id: 'L1',
        title: 'Lesson 1: Representations of Functions',
        shortDesc: 'Relations, Functions & Piecewise',
        content: [
          const TextSpanBuilder(
            title: "1. Relations vs. Functions",
            body: "A relation is a rule that relates values from a set of values (called the domain) to a second set of values (called the range).\n\nA function is a special type of relation where each element in the domain is related to exactly one value in the range.",
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: Colors.black, width: 3)),
            ),
            child: const Text(
              "\"No two ordered pairs have the same x-value but different y-values.\"",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          const TextSpanBuilder(
            title: "2. Determining a Function",
            body: "• Ordered Pairs: Look at the x-coordinates. If all x-values are unique, it is a function.\n\n• Vertical Line Test: A graph represents a function if and only if each vertical line intersects the graph at most once.",
          ),
          const SizedBox(height: 16),
          const TextSpanBuilder(
            title: "3. Piece-wise Functions",
            body: "Some real-life situations require more than one formula to describe the function. These are functions defined by multiple sub-functions applying to a certain interval of the domain.",
          ),
        ],
        example: "Cost of Cupcakes P(c):\n15c        if 0 < c ≤ 100\n13.50c   if 100 < c ≤ 150\n10c        if c > 150",
        quizzes: {
          'easy': [
            Question(
              text: "Which of the following represents a function?",
              options: ["Students to their LRN", "Countries to their capitals", "A store to its merchandise", "Teacher to students"],
              correctIndex: 0,
              explanation: "Each student has a unique Learner Reference Number (LRN), making it a One-to-One correspondence.",
            ),
          ],
          'medium': [
            Question(
              text: "Given relation A = {(5,2), (7,4), (9,10), (x,5)}. Which value of x makes it a function?",
              options: ["5", "7", "9", "4"],
              correctIndex: 3,
              explanation: "For it to be a function, x cannot be 5, 7, or 9 because those domains are already taken. 4 is unique.",
            ),
          ],
          'hard': [
            Question(
              text: "A user is charged P300 monthly for a plan with 100 free texts. Excess texts are P1 each. Represent cost t(m) for m > 100.",
              options: ["t(m) = 300 + m", "t(m) = 300 + (m-100)", "t(m) = 300m"],
              correctIndex: 1,
              explanation: "You pay the base 300 plus 1 peso for every message ABOVE 100 (m-100).",
            ),
          ],
        },
      ),
      Topic(
        id: 'L2',
        title: 'Lesson 2: Evaluating Functions',
        shortDesc: 'Substitution & PEMDAS',
        content: [
          const TextSpanBuilder(
            title: "Evaluating a Function",
            body: "Evaluating a function means replacing the variable in the function (usually x) with a value from the function's domain and computing the result. We write this as f(a).",
          ),
          const SizedBox(height: 16),
          const TextSpanBuilder(
            title: "Steps to Evaluate",
            body: "1. Substitute: Directly replace the indicated value to the given function.\n2. Perform Operations: Follow PEMDAS (Parentheses, Exponents, Multiplication/Division, Addition/Subtraction).\n3. Simplify: Combine like terms.",
          ),
        ],
        example: "Evaluate f(x) = 4x + 1 at x = 1.5\nf(1.5) = 4(1.5) + 1\n= 6 + 1\n= 7",
        quizzes: {
          'easy': [
            Question(
              text: "If f(x) = -2x² - 3, find f(0).",
              options: ["-5", "-3", "0", "3"],
              correctIndex: 1,
              explanation: "Substitute 0: -2(0)² - 3 = 0 - 3 = -3.",
            ),
          ],
          'medium': [
            Question(
              text: "If g(x) = -8x + 1, find g(-2).",
              options: ["-7", "1", "10", "17"],
              correctIndex: 3,
              explanation: "g(-2) = -8(-2) + 1 = 16 + 1 = 17.",
            ),
          ],
          'hard': [
            Question(
              text: "Given piecewise f(x) = {4-x² if x<3; √x+7 if 3≤x<11}. Find f(9).",
              options: ["4", "3", "-4", "16"],
              correctIndex: 0,
              explanation: "9 is between 3 and 11. Use √x+7. √9+7 = √16 = 4.",
            ),
          ],
        },
      ),
      Topic(
        id: 'L3',
        title: 'Lesson 3: Operations on Functions',
        shortDesc: 'Sum, Diff, Product, Quotient & Composition',
        content: [
          const TextSpanBuilder(
            title: "Operations",
            body: "Functions can be added, subtracted, multiplied, and divided.\n\n• Sum: (f+g)(x) = f(x) + g(x)\n• Difference: (f-g)(x) = f(x) - g(x)\n• Product: (f • g)(x) = f(x) • g(x)\n• Quotient: (f/g)(x) = f(x) / g(x)",
          ),
          const SizedBox(height: 16),
          const TextSpanBuilder(
            title: "Composition of Functions",
            body: "The composite function denoted by (f ∘ g) is defined by (f ∘ g)(x) = f(g(x)). The process involves using the output of the inner function g(x) as the input for the outer function f(x).",
          ),
        ],
        example: "Let f(x) = 2x+1, g(x) = x²-2x+2\n(f+g)(x) = (2x+1) + (x²-2x+2)\n= x² + 1 + 2\n= x² + 3",
        quizzes: {
          'easy': [
            Question(
              text: "Which defines the sum of f + h?",
              options: ["f(x) + h(x)", "f(x) - h(x)", "f(h(x))", "f(x)h(x)"],
              correctIndex: 0,
              explanation: "The sum is simply adding the two function expressions.",
            ),
          ],
          'medium': [
            Question(
              text: "If f(x) = 2x and g(x) = x+5, find (f • g)(x).",
              options: ["2x² + 5", "2x² + 10x", "x + 5", "2x + 10"],
              correctIndex: 1,
              explanation: "2x(x + 5) = 2x² + 10x.",
            ),
          ],
          'hard': [
            Question(
              text: "Given f(x) = 2x and g(x) = x+5, find (f ∘ g)(x).",
              options: ["2x + 5", "2x + 10", "x + 10", "2x² + 5"],
              correctIndex: 1,
              explanation: "f(g(x)) = f(x+5) = 2(x+5) = 2x + 10.",
            ),
          ],
        },
      ),
      Topic(
        id: 'L4',
        title: 'Lesson 4: Problem Solving',
        shortDesc: 'Real-life Applications',
        content: [
          const TextSpanBuilder(
            title: "4-Step Rule",
            body: "1. READ: Identify given info and what is asked.\n2. PLAN: Find a word sentence to suggest an equation.\n3. SOLVE: Use algebraic properties.\n4. CHECK: Examine if the answer satisfies the conditions.",
          ),
          const SizedBox(height: 16),
          const TextSpanBuilder(
            title: "Common Applications",
            body: "• Cost Functions: Taxi fares, wages.\n• Geometry: Area/Perimeter as function of width.\n• Direct Variation: Map distances vs actual distances.",
          ),
        ],
        example: "Taxi Fare: P25 initial + P1 per 500m.\nFunction: f(x) = 25 + 1x\n(where x is number of 500m units)",
        quizzes: {
          'easy': [
            Question(
              text: "The wage is P30/hr. Express total salary f(x) for x hours.",
              options: ["f(x) = 30 + x", "f(x) = 30x", "f(x) = x/30", "f(x) = 30"],
              correctIndex: 1,
              explanation: "Wage = Rate * Time. So f(x) = 30x.",
            ),
          ],
          'medium': [
            Question(
              text: "Map scale: 1cm = 25km. How many km is 7cm?",
              options: ["150 km", "175 km", "200 km", "225 km"],
              correctIndex: 1,
              explanation: "f(x) = 25x. f(7) = 25(7) = 175.",
            ),
          ],
          'hard': [
            Question(
              text: "Rectangle perimeter is 56cm. Length is 4cm greater than width. Find width.",
              options: ["10", "12", "15", "16"],
              correctIndex: 1,
              explanation: "P = 2L + 2W. 56 = 2(w+4) + 2w. 56 = 4w + 8. 48 = 4w. w=12.",
            ),
          ],
        },
      ),
    ],
  ),
];
