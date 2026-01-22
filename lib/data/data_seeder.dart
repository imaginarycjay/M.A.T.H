import 'database.dart';
import 'mock_modules.dart';

class DataSeeder {
  final AppDatabase _db = AppDatabase.instance;

  // Convert mock modules to database format and seed
  Future<void> seedFromMockData() async {
    final isSeeded = await _db.isSeeded();
    if (isSeeded) {
      print('Database already seeded, skipping...');
      return;
    }

    print('Seeding database with mock data...');

    final modulesData = <Map<String, dynamic>>[];

    for (final module in appModules) {
      final topicsData = <Map<String, dynamic>>[];

      for (final topic in module.topics) {
        final questionsData = <Map<String, dynamic>>[];

        // Extract all questions from quizzes
        topic.quizzes.forEach((difficulty, questions) {
          for (final question in questions) {
            questionsData.add({
              'difficulty': difficulty,
              'text': question.text,
              'options': question.options,
              'correct_index': question.correctIndex,
              'explanation': question.explanation,
            });
          }
        });

        topicsData.add({
          'id': topic.id,
          'title': topic.title,
          'short_desc': topic.shortDesc,
          'example': topic.example,
          'content_json': '[]', // Content widgets can't be serialized
          'questions': questionsData,
        });
      }

      modulesData.add({
        'id': module.id,
        'title': module.title,
        'description': module.description,
        'topics': topicsData,
      });
    }

    await _db.seedData(modulesData);
    print('Database seeded successfully!');
  }

  // Initialize default user settings
  Future<void> seedDefaultSettings() async {
    final db = await _db.database;

    final existingSettings = await db.query('user_settings', limit: 1);
    if (existingSettings.isNotEmpty) return;

    await db.insert('user_settings', {'key': 'theme_mode', 'value': 'light'});
    await db.insert('user_settings', {'key': 'notifications_enabled', 'value': 'true'});
    await db.insert('user_settings', {'key': 'first_launch', 'value': 'true'});
  }
}
