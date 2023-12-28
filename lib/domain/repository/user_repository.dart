import 'package:nikki_app/db/hive_database.dart';

import '../../data/diary_entry.dart';
import '../../utils/get_it_init.dart';

class UserRepository {
   //final AppDatabase _database = getIt.get<AppDatabase>();
   final String username = "default";
   bool isLoading = false;
   List<DiaryEntryData> personalEntries = []; //load from db
   List<DiaryEntryData> sharedEntries = []; //load from db
   DiaryEntryData? diaryEntry;


   Future<String> loadUsername() async {
    // Simulate loading from a database or other source
    await Future.delayed(const Duration(seconds: 2));
    return username;
  }



  setLoading() => isLoading = true;

  Future<void> addDiaryEntry(DiaryEntryData diaryEntryData) async {
    personalEntries.add(diaryEntryData);
    diaryEntry = diaryEntryData;
    try {
      //await _database.putDiaryEntry(diaryEntryData);
    } catch (e) {
      print(e);
      print("Couldn't write to database");
    }
  }

  Future<void> loadDiaryEntries() async {
    try {
      setLoading();
      //personalEntries = await _database.getDiaryEntries();
      isLoading = false;
    } catch (e) {
      // Handle exceptions if needed
    }
  }
}