import 'package:flutter/material.dart';
import 'app.dart';
import 'data/learning_database.dart';
import 'utils/sound_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the learning database
  await LearningDatabase.instance.database;

  // Initialize sound manager
  await SoundManager.instance.init();

  runApp(const LearnMathApp());
}
