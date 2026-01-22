import 'database.dart';

class StudyPlanRepository {
  final AppDatabase _db = AppDatabase.instance;

  // Add a topic to study plan
  Future<int> addToStudyPlan({
    required String topicId,
    required DateTime scheduledDate,
    String? notes,
  }) async {
    final db = await _db.database;
    return await db.insert('study_plan', {
      'topic_id': topicId,
      'scheduled_date': scheduledDate.millisecondsSinceEpoch,
      'is_completed': 0,
      'notes': notes,
    });
  }

  // Get study plan items
  Future<List<Map<String, dynamic>>> getStudyPlan({bool includeCompleted = false}) async {
    final db = await _db.database;

    String? where;
    if (!includeCompleted) {
      where = 'is_completed = 0';
    }

    return await db.query(
      'study_plan',
      where: where,
      orderBy: 'scheduled_date ASC',
    );
  }

  // Get study plan for a specific date
  Future<List<Map<String, dynamic>>> getStudyPlanForDate(DateTime date) async {
    final db = await _db.database;
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    return await db.query(
      'study_plan',
      where: 'scheduled_date >= ? AND scheduled_date <= ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'scheduled_date ASC',
    );
  }

  // Mark study plan item as completed
  Future<void> markAsCompleted(int planId, bool completed) async {
    final db = await _db.database;
    await db.update(
      'study_plan',
      {'is_completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [planId],
    );
  }

  // Update study plan item
  Future<void> updateStudyPlan({
    required int planId,
    DateTime? scheduledDate,
    String? notes,
    bool? isCompleted,
  }) async {
    final db = await _db.database;
    final updates = <String, dynamic>{};

    if (scheduledDate != null) {
      updates['scheduled_date'] = scheduledDate.millisecondsSinceEpoch;
    }
    if (notes != null) {
      updates['notes'] = notes;
    }
    if (isCompleted != null) {
      updates['is_completed'] = isCompleted ? 1 : 0;
    }

    if (updates.isNotEmpty) {
      await db.update(
        'study_plan',
        updates,
        where: 'id = ?',
        whereArgs: [planId],
      );
    }
  }

  // Delete study plan item
  Future<void> deleteStudyPlanItem(int planId) async {
    final db = await _db.database;
    await db.delete(
      'study_plan',
      where: 'id = ?',
      whereArgs: [planId],
    );
  }

  // Get upcoming study items (next 7 days)
  Future<List<Map<String, dynamic>>> getUpcomingStudy() async {
    final db = await _db.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final weekLater = DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;

    return await db.query(
      'study_plan',
      where: 'scheduled_date >= ? AND scheduled_date <= ? AND is_completed = 0',
      whereArgs: [now, weekLater],
      orderBy: 'scheduled_date ASC',
    );
  }
}
