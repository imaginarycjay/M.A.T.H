import 'package:flutter/material.dart';
import 'app.dart';
import 'data/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and seed database on first run
  final seeder = DataSeeder();
  await seeder.seedFromMockData();
  await seeder.seedDefaultSettings();

  runApp(const TutoringHubApp());
}
