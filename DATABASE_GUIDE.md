# Database Implementation Guide

## Overview
The app now uses SQLite for local data persistence with the following structure:

## Database Schema

### Tables

1. **modules**
   - `id` (TEXT, PRIMARY KEY)
   - `title` (TEXT)
   - `description` (TEXT)

2. **topics**
   - `id` (TEXT, PRIMARY KEY)
   - `module_id` (TEXT, FOREIGN KEY)
   - `title` (TEXT)
   - `short_desc` (TEXT)
   - `example` (TEXT)
   - `content_json` (TEXT) - Placeholder for future content serialization

3. **questions**
   - `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
   - `topic_id` (TEXT, FOREIGN KEY)
   - `difficulty` (TEXT) - 'easy', 'medium', or 'hard'
   - `text` (TEXT)
   - `options_json` (TEXT) - JSON array of answer options
   - `correct_index` (INTEGER)
   - `explanation` (TEXT)

4. **quiz_attempts** (User Progress)
   - `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
   - `topic_id` (TEXT, FOREIGN KEY)
   - `difficulty` (TEXT)
   - `score` (INTEGER)
   - `total` (INTEGER)
   - `timestamp` (INTEGER) - Milliseconds since epoch

5. **topic_progress**
   - `topic_id` (TEXT, PRIMARY KEY)
   - `is_completed` (INTEGER) - 0 or 1
   - `last_accessed` (INTEGER) - Milliseconds since epoch

6. **user_settings**
   - `key` (TEXT, PRIMARY KEY)
   - `value` (TEXT)

7. **study_plan**
   - `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
   - `topic_id` (TEXT, FOREIGN KEY)
   - `scheduled_date` (INTEGER) - Milliseconds since epoch
   - `is_completed` (INTEGER) - 0 or 1
   - `notes` (TEXT, nullable)

## Repository Classes

### ModuleRepository (`lib/data/module_repository.dart`)
Handles all module and topic-related operations:
- `getAllModules()` - Get all modules with topics and quizzes
- `getModuleById(moduleId)` - Get a specific module
- `getTopicById(topicId)` - Get a specific topic
- `saveQuizAttempt()` - Save a quiz attempt
- `getQuizAttempts(topicId)` - Get quiz history for a topic
- `updateTopicProgress()` - Track when a topic is accessed/completed
- `getProgressStats()` - Get overall statistics

### SettingsRepository (`lib/data/settings_repository.dart`)
Manages user settings:
- `getSetting(key)` - Get a setting value
- `setSetting(key, value)` - Set a setting value
- `getAllSettings()` - Get all settings
- `deleteSetting(key)` - Delete a setting

### StudyPlanRepository (`lib/data/study_plan_repository.dart`)
Manages study planning:
- `addToStudyPlan()` - Add a topic to the study plan
- `getStudyPlan()` - Get all study plan items
- `getStudyPlanForDate(date)` - Get items for a specific date
- `markAsCompleted(planId, completed)` - Mark item as done
- `updateStudyPlan()` - Update study plan details
- `deleteStudyPlanItem(planId)` - Remove from study plan
- `getUpcomingStudy()` - Get upcoming items (next 7 days)

## Data Flow

1. **App Initialization** (`main.dart`)
   - Database is initialized and seeded from `mock_modules.dart` on first run
   - Default settings are seeded

2. **Screens Load Data**
   - Screens use repositories to fetch data from database
   - Topic content widgets are still loaded from `mock_modules.dart` (not serializable)

3. **User Progress Tracking**
   - Quiz attempts are automatically saved when completed
   - Topic access is tracked when viewed
   - Progress statistics are calculated from database

## Backup & Export

The database includes export/import functionality:

```dart
// Export all data as JSON
final db = AppDatabase.instance;
final jsonBackup = await db.exportData();

// Import from JSON backup
await db.importData(jsonBackup);
```

This can be used to:
- Create backups before app uninstall
- Transfer data between devices
- Restore user progress

## Future Enhancements

- Serialize Widget content for full offline storage
- Add sync preparation (conflict resolution, change tracking)
- Implement cloud backup integration
- Add data analytics and insights
- Support multiple users/profiles
