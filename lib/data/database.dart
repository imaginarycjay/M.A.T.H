import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();
  AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tutorhub.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Modules table
    await db.execute('''
      CREATE TABLE modules (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    // Topics table
    await db.execute('''
      CREATE TABLE topics (
        id TEXT PRIMARY KEY,
        module_id TEXT NOT NULL,
        title TEXT NOT NULL,
        short_desc TEXT NOT NULL,
        example TEXT NOT NULL,
        content_json TEXT NOT NULL,
        FOREIGN KEY (module_id) REFERENCES modules (id) ON DELETE CASCADE
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        text TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_index INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
      )
    ''');

    // Quiz attempts table (user progress)
    await db.execute('''
      CREATE TABLE quiz_attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
      )
    ''');

    // Topic progress table
    await db.execute('''
      CREATE TABLE topic_progress (
        topic_id TEXT PRIMARY KEY,
        is_completed INTEGER DEFAULT 0,
        last_accessed INTEGER,
        FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
      )
    ''');

    // User settings table
    await db.execute('''
      CREATE TABLE user_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Study plan table
    await db.execute('''
      CREATE TABLE study_plan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id TEXT NOT NULL,
        scheduled_date INTEGER NOT NULL,
        is_completed INTEGER DEFAULT 0,
        notes TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
      )
    ''');
  }

  // Check if database is seeded
  Future<bool> isSeeded() async {
    final db = await database;
    final result = await db.query('modules', limit: 1);
    return result.isNotEmpty;
  }

  // Seed database with initial data
  Future<void> seedData(List<Map<String, dynamic>> modulesData) async {
    final db = await database;
    final batch = db.batch();

    for (final moduleData in modulesData) {
      // Insert module
      batch.insert('modules', {
        'id': moduleData['id'],
        'title': moduleData['title'],
        'description': moduleData['description'],
      });

      // Insert topics
      for (final topicData in moduleData['topics']) {
        batch.insert('topics', {
          'id': topicData['id'],
          'module_id': moduleData['id'],
          'title': topicData['title'],
          'short_desc': topicData['short_desc'],
          'example': topicData['example'],
          'content_json': topicData['content_json'],
        });

        // Initialize topic progress
        batch.insert('topic_progress', {
          'topic_id': topicData['id'],
          'is_completed': 0,
          'last_accessed': null,
        });

        // Insert questions
        for (final questionData in topicData['questions']) {
          batch.insert('questions', {
            'topic_id': topicData['id'],
            'difficulty': questionData['difficulty'],
            'text': questionData['text'],
            'options_json': jsonEncode(questionData['options']),
            'correct_index': questionData['correct_index'],
            'explanation': questionData['explanation'],
          });
        }
      }
    }

    await batch.commit(noResult: true);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Export all data as JSON for backup
  Future<String> exportData() async {
    final db = await database;
    final modules = await db.query('modules');
    final topics = await db.query('topics');
    final questions = await db.query('questions');
    final attempts = await db.query('quiz_attempts');
    final progress = await db.query('topic_progress');
    final settings = await db.query('user_settings');
    final studyPlan = await db.query('study_plan');

    final data = {
      'modules': modules,
      'topics': topics,
      'questions': questions,
      'quiz_attempts': attempts,
      'topic_progress': progress,
      'user_settings': settings,
      'study_plan': studyPlan,
      'version': 1,
      'exported_at': DateTime.now().millisecondsSinceEpoch,
    };

    return jsonEncode(data);
  }

  // Import data from JSON backup
  Future<void> importData(String jsonString) async {
    final db = await database;
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Clear existing data
    await db.delete('study_plan');
    await db.delete('quiz_attempts');
    await db.delete('topic_progress');
    await db.delete('questions');
    await db.delete('topics');
    await db.delete('modules');
    await db.delete('user_settings');

    final batch = db.batch();

    // Import modules
    for (final module in (data['modules'] as List)) {
      batch.insert('modules', Map<String, dynamic>.from(module));
    }

    // Import topics
    for (final topic in (data['topics'] as List)) {
      batch.insert('topics', Map<String, dynamic>.from(topic));
    }

    // Import questions
    for (final question in (data['questions'] as List)) {
      batch.insert('questions', Map<String, dynamic>.from(question));
    }

    // Import attempts
    if (data['quiz_attempts'] != null) {
      for (final attempt in (data['quiz_attempts'] as List)) {
        batch.insert('quiz_attempts', Map<String, dynamic>.from(attempt));
      }
    }

    // Import progress
    if (data['topic_progress'] != null) {
      for (final progress in (data['topic_progress'] as List)) {
        batch.insert('topic_progress', Map<String, dynamic>.from(progress));
      }
    }

    // Import settings
    if (data['user_settings'] != null) {
      for (final setting in (data['user_settings'] as List)) {
        batch.insert('user_settings', Map<String, dynamic>.from(setting));
      }
    }

    // Import study plan
    if (data['study_plan'] != null) {
      for (final plan in (data['study_plan'] as List)) {
        batch.insert('study_plan', Map<String, dynamic>.from(plan));
      }
    }

    await batch.commit(noResult: true);
  }
}
