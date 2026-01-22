import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/learning_node.dart';
import 'learning_content.dart';

class LearningDatabase {
  static final LearningDatabase instance = LearningDatabase._();
  LearningDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'learning_path.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Node progress table
    await db.execute('''
      CREATE TABLE node_progress (
        node_id TEXT PRIMARY KEY,
        status INTEGER DEFAULT 0,
        stars_earned INTEGER DEFAULT 0,
        attempts INTEGER DEFAULT 0,
        last_score INTEGER,
        completed_at INTEGER
      )
    ''');

    // User settings table
    await db.execute('''
      CREATE TABLE user_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Game attempts history
    await db.execute('''
      CREATE TABLE game_attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        node_id TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        stars_earned INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (node_id) REFERENCES node_progress (node_id) ON DELETE CASCADE
      )
    ''');

    // Initialize progress for all nodes
    await _initializeNodeProgress(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old tables and recreate
      await db.execute('DROP TABLE IF EXISTS modules');
      await db.execute('DROP TABLE IF EXISTS topics');
      await db.execute('DROP TABLE IF EXISTS questions');
      await db.execute('DROP TABLE IF EXISTS quiz_attempts');
      await db.execute('DROP TABLE IF EXISTS topic_progress');
      await db.execute('DROP TABLE IF EXISTS study_plan');

      // Create new tables
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _initializeNodeProgress(Database db) async {
    final batch = db.batch();

    for (int i = 0; i < LearningContent.nodes.length; i++) {
      final node = LearningContent.nodes[i];
      batch.insert('node_progress', {
        'node_id': node.id,
        'status': i == 0 ? NodeStatus.unlocked.index : NodeStatus.locked.index,
        'stars_earned': 0,
        'attempts': 0,
        'last_score': null,
        'completed_at': null,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    await batch.commit(noResult: true);
  }

  // Get progress for a specific node
  Future<NodeProgress?> getNodeProgress(String nodeId) async {
    final db = await database;
    final results = await db.query(
      'node_progress',
      where: 'node_id = ?',
      whereArgs: [nodeId],
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return NodeProgress(
      nodeId: row['node_id'] as String,
      status: NodeStatus.values[row['status'] as int],
      starsEarned: row['stars_earned'] as int,
      attempts: row['attempts'] as int,
      lastScore: row['last_score'] as int?,
      completedAt: row['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['completed_at'] as int)
          : null,
    );
  }

  // Get all node progress
  Future<Map<String, NodeProgress>> getAllProgress() async {
    final db = await database;
    final results = await db.query('node_progress');

    final progressMap = <String, NodeProgress>{};
    for (final row in results) {
      final progress = NodeProgress(
        nodeId: row['node_id'] as String,
        status: NodeStatus.values[row['status'] as int],
        starsEarned: row['stars_earned'] as int,
        attempts: row['attempts'] as int,
        lastScore: row['last_score'] as int?,
        completedAt: row['completed_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['completed_at'] as int)
            : null,
      );
      progressMap[progress.nodeId] = progress;
    }

    // Ensure all nodes have progress entries
    for (final node in LearningContent.nodes) {
      if (!progressMap.containsKey(node.id)) {
        final status = node.order == 1 ? NodeStatus.unlocked : NodeStatus.locked;
        progressMap[node.id] = NodeProgress(
          nodeId: node.id,
          status: status,
        );
      }
    }

    return progressMap;
  }

  // Update node progress
  Future<void> updateNodeProgress(NodeProgress progress) async {
    final db = await database;
    await db.update(
      'node_progress',
      {
        'status': progress.status.index,
        'stars_earned': progress.starsEarned,
        'attempts': progress.attempts,
        'last_score': progress.lastScore,
        'completed_at': progress.completedAt?.millisecondsSinceEpoch,
      },
      where: 'node_id = ?',
      whereArgs: [progress.nodeId],
    );
  }

  // Complete a node and unlock the next one
  Future<void> completeNode(String nodeId, {int stars = 0, int score = 0}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Get current progress
    final currentProgress = await getNodeProgress(nodeId);
    final newAttempts = (currentProgress?.attempts ?? 0) + 1;

    // Update current node as completed
    await db.update(
      'node_progress',
      {
        'status': NodeStatus.completed.index,
        'stars_earned': stars,
        'attempts': newAttempts,
        'last_score': score,
        'completed_at': now,
      },
      where: 'node_id = ?',
      whereArgs: [nodeId],
    );

    // Record attempt
    await db.insert('game_attempts', {
      'node_id': nodeId,
      'score': score,
      'total': 100,
      'stars_earned': stars,
      'timestamp': now,
    });

    // Unlock next node
    final currentNode = LearningContent.getNodeById(nodeId);
    if (currentNode != null) {
      final nextNode = LearningContent.getNextNode(nodeId);
      if (nextNode != null) {
        await db.update(
          'node_progress',
          {'status': NodeStatus.unlocked.index},
          where: 'node_id = ? AND status = ?',
          whereArgs: [nextNode.id, NodeStatus.locked.index],
        );
      }
    }
  }

  // Record a failed attempt (node stays unlocked but not completed)
  Future<void> recordFailedAttempt(String nodeId, {int stars = 0, int score = 0}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Get current progress
    final currentProgress = await getNodeProgress(nodeId);
    final newAttempts = (currentProgress?.attempts ?? 0) + 1;
    final maxStars = (currentProgress?.starsEarned ?? 0) > stars
        ? currentProgress!.starsEarned
        : stars;

    // Update attempts but keep unlocked status
    await db.update(
      'node_progress',
      {
        'attempts': newAttempts,
        'last_score': score,
        'stars_earned': maxStars,
      },
      where: 'node_id = ?',
      whereArgs: [nodeId],
    );

    // Record attempt
    await db.insert('game_attempts', {
      'node_id': nodeId,
      'score': score,
      'total': 100,
      'stars_earned': stars,
      'timestamp': now,
    });
  }

  // Get user setting
  Future<String?> getSetting(String key) async {
    final db = await database;
    final results = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (results.isEmpty) return null;
    return results.first['value'] as String;
  }

  // Set user setting
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Reset all progress
  Future<void> resetProgress() async {
    final db = await database;

    // Clear attempts
    await db.delete('game_attempts');

    // Reset all node progress
    final batch = db.batch();
    for (int i = 0; i < LearningContent.nodes.length; i++) {
      final node = LearningContent.nodes[i];
      batch.update(
        'node_progress',
        {
          'status': i == 0 ? NodeStatus.unlocked.index : NodeStatus.locked.index,
          'stars_earned': 0,
          'attempts': 0,
          'last_score': null,
          'completed_at': null,
        },
        where: 'node_id = ?',
        whereArgs: [node.id],
      );
    }
    await batch.commit(noResult: true);
  }

  // Get total stars earned
  Future<int> getTotalStars() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(stars_earned) as total FROM node_progress WHERE status = ?',
      [NodeStatus.completed.index],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  // Get completion percentage
  Future<double> getCompletionPercentage() async {
    final db = await database;
    final completed = await db.rawQuery(
      'SELECT COUNT(*) as count FROM node_progress WHERE status = ?',
      [NodeStatus.completed.index],
    );
    final total = LearningContent.nodes.length;
    final completedCount = (completed.first['count'] as int?) ?? 0;
    return total > 0 ? (completedCount / total) * 100 : 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Delete database and reset
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'learning_path.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
