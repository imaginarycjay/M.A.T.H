import 'package:sqflite/sqflite.dart';
import 'database.dart';

class SettingsRepository {
  final AppDatabase _db = AppDatabase.instance;

  // Get a setting value
  Future<String?> getSetting(String key) async {
    final db = await _db.database;
    final results = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.first['value'] as String?;
  }

  // Set a setting value
  Future<void> setSetting(String key, String value) async {
    final db = await _db.database;
    await db.insert(
      'user_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all settings
  Future<Map<String, String>> getAllSettings() async {
    final db = await _db.database;
    final results = await db.query('user_settings');

    final settings = <String, String>{};
    for (final row in results) {
      settings[row['key'] as String] = row['value'] as String;
    }
    return settings;
  }

  // Delete a setting
  Future<void> deleteSetting(String key) async {
    final db = await _db.database;
    await db.delete(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
