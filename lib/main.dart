import 'package:flutter/material.dart';
import 'app.dart';
import 'data/learning_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the learning database
  await LearningDatabase.instance.database;

  runApp(const LearnMathApp());
}
