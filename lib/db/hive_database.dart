import 'package:nikki_app/data/diary_entry.dart';

import '../utils/get_it_init.dart';
import 'package:hive/hive.dart';
import 'database_adapter.dart';



class AppDatabase extends DatabaseAdapter {
  late final Box<DiaryEntryData> diaryEntryBox;
  AppDatabase() {
    openHiveBoxes();
  }

  Future<void> openHiveBoxes() async {
    diaryEntryBox = await Hive.openBox<DiaryEntryData>('diary_entries');
  }
}