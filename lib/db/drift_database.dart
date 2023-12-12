import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;
import 'package:path_provider/path_provider.dart';

import '../model/diary_entry.dart';

part 'drift_database.g.dart';


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));

    if (!await file.exists()) {
      final blob = await rootBundle.load('assets/my_database.db');
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }

    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Users, DiaryEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (details) async {},
    );
  }
}

@DataClassName('User')
class Users extends Table {
  TextColumn get username => text().customConstraint('UNIQUE')();
  TextColumn get uuid => text()();
}

@DataClassName('DiaryEntry')
class DiaryEntries extends Table {
  TextColumn get username =>
      text().customConstraint('REFERENCES users(username)')();
  TextColumn get description => text()();
  DateTimeColumn get datetime => dateTime()();
  BlobColumn get photo => blob().nullable()();
}