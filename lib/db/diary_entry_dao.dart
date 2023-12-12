// diary_entry_dao.dart

import 'package:drift/drift.dart';
import 'drift_database.dart'; // Adjust the import path

@DriftDao(tables: [DiaryEntries])
class DiaryEntryDao extends DatabaseAccessor<AppDatabase> with _$DiaryEntryDaoMixin {
  DiaryEntryDao(QueryRowDao db) : super(db);

  Future<List<DiaryEntry>> getAllEntries() => select(diaryEntries).get();
}

@DriftDao