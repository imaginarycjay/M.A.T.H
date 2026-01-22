import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/module.dart';
import '../models/topic.dart';
import '../models/question.dart';
import 'database.dart';

class ModuleRepository {
  final AppDatabase _db = AppDatabase.instance;

  // Get all modules
  Future<List<Module>> getAllModules() async {
    final db = await _db.database;
    final modulesData = await db.query('modules');

    final modules = <Module>[];
    for (final moduleData in modulesData) {
      final topics = await _getTopicsForModule(moduleData['id'] as String);
      modules.add(Module(
        id: moduleData['id'] as String,
        title: moduleData['title'] as String,
        description: moduleData['description'] as String,
        topics: topics,
      ));
    }

    return modules;
  }

  // Get module by ID
  Future<Module?> getModuleById(String moduleId) async {
    final db = await _db.database;
    final results = await db.query(
      'modules',
      where: 'id = ?',
      whereArgs: [moduleId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final moduleData = results.first;
    final topics = await _getTopicsForModule(moduleId);

    return Module(
      id: moduleData['id'] as String,
      title: moduleData['title'] as String,
      description: moduleData['description'] as String,
      topics: topics,
    );
  }

  // Get topics for a module
  Future<List<Topic>> _getTopicsForModule(String moduleId) async {
    final db = await _db.database;
    final topicsData = await db.query(
      'topics',
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );

    final topics = <Topic>[];
    for (final topicData in topicsData) {
      final quizzes = await _getQuizzesForTopic(topicData['id'] as String);

      // Decode content JSON - for now we'll store it as empty list
      // since Widget content can't be serialized easily
      topics.add(Topic(
        id: topicData['id'] as String,
        title: topicData['title'] as String,
        shortDesc: topicData['short_desc'] as String,
        content: [], // Will be populated from static data when needed
        example: topicData['example'] as String,
        quizzes: quizzes,
      ));
    }

    return topics;
  }

  // Get quizzes for a topic
  Future<Map<String, List<Question>>> _getQuizzesForTopic(String topicId) async {
    final db = await _db.database;
    final questionsData = await db.query(
      'questions',
      where: 'topic_id = ?',
      whereArgs: [topicId],
    );

    final quizzes = <String, List<Question>>{
      'easy': [],
      'medium': [],
      'hard': [],
    };

    for (final questionData in questionsData) {
      final difficulty = questionData['difficulty'] as String;
      final options = (jsonDecode(questionData['options_json'] as String) as List)
          .map((e) => e.toString())
          .toList();

      final question = Question(
        text: questionData['text'] as String,
        options: options,
        correctIndex: questionData['correct_index'] as int,
        explanation: questionData['explanation'] as String,
      );

      quizzes[difficulty]?.add(question);
    }

    return quizzes;
  }

  // Get topic by ID
  Future<Topic?> getTopicById(String topicId) async {
    final db = await _db.database;
    final results = await db.query(
      'topics',
      where: 'id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final topicData = results.first;
    final quizzes = await _getQuizzesForTopic(topicId);

    return Topic(
      id: topicData['id'] as String,
      title: topicData['title'] as String,
      shortDesc: topicData['short_desc'] as String,
      content: [],
      example: topicData['example'] as String,
      quizzes: quizzes,
    );
  }

  // Save quiz attempt
  Future<void> saveQuizAttempt({
    required String topicId,
    required String difficulty,
    required int score,
    required int total,
  }) async {
    final db = await _db.database;
    await db.insert('quiz_attempts', {
      'topic_id': topicId,
      'difficulty': difficulty,
      'score': score,
      'total': total,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Get quiz attempts for a topic
  Future<List<Map<String, dynamic>>> getQuizAttempts(String topicId) async {
    final db = await _db.database;
    return await db.query(
      'quiz_attempts',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'timestamp DESC',
    );
  }

  // Get all quiz attempts
  Future<List<Map<String, dynamic>>> getAllQuizAttempts() async {
    final db = await _db.database;
    return await db.query(
      'quiz_attempts',
      orderBy: 'timestamp DESC',
    );
  }

  // Update topic progress
  Future<void> updateTopicProgress({
    required String topicId,
    bool? isCompleted,
  }) async {
    final db = await _db.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final existing = await db.query(
      'topic_progress',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert('topic_progress', {
        'topic_id': topicId,
        'is_completed': isCompleted == true ? 1 : 0,
        'last_accessed': now,
      });
    } else {
      final updates = <String, dynamic>{
        'last_accessed': now,
      };
      if (isCompleted != null) {
        updates['is_completed'] = isCompleted ? 1 : 0;
      }
      await db.update(
        'topic_progress',
        updates,
        where: 'topic_id = ?',
        whereArgs: [topicId],
      );
    }
  }

  // Get topic progress
  Future<Map<String, dynamic>?> getTopicProgress(String topicId) async {
    final db = await _db.database;
    final results = await db.query(
      'topic_progress',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    return results.isEmpty ? null : results.first;
  }

  // Get overall progress statistics
  Future<Map<String, dynamic>> getProgressStats() async {
    final db = await _db.database;

    final totalTopics = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM topics'),
    ) ?? 0;

    final completedTopics = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM topic_progress WHERE is_completed = 1'),
    ) ?? 0;

    final totalAttempts = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM quiz_attempts'),
    ) ?? 0;

    final averageScore = await db.rawQuery(
      'SELECT AVG(CAST(score AS REAL) / CAST(total AS REAL) * 100) as avg FROM quiz_attempts',
    );

    return {
      'total_topics': totalTopics,
      'completed_topics': completedTopics,
      'total_attempts': totalAttempts,
      'average_score': (averageScore.first['avg'] as num?)?.toDouble() ?? 0.0,
    };
  }
}
