import 'package:flutter/material.dart';
import 'question.dart';

class Topic {
  final String id;
  final String title;
  final String shortDesc;
  final List<Widget> content;
  final String example;
  final Map<String, List<Question>> quizzes;

  const Topic({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.content,
    required this.example,
    required this.quizzes,
  });
}
