import 'package:nikki_app/config/app_config.dart';
import 'package:nikki_app/db/hive_database.dart';
import 'package:nikki_app/db/nikki_shared_pref.dart';

import '../../data/diary_entry.dart';
import '../../utils/get_it_init.dart';

class UserRepository {
   final AppDatabase _database = getIt.get<AppDatabase>();
   final AppConfig appConfig = AppConfig();
   String username = "default";
   List<DiaryEntryData> personalEntries = []; //load from db
   List<DiaryEntryData> sharedEntries = []; //load from db
   DiaryEntryData? diaryEntry;


  Future<String> loadPrompt() async{
    var sharedPreferences = NikkiSharedPreferences();
    await sharedPreferences.init();
    var prompt = await sharedPreferences.getPrompt();
    if(prompt.isEmpty){
      prompt = await appConfig.fetchData();
      sharedPreferences.setPrompt(prompt);
    }
    return prompt;
  }

  Future<void> generateNewPrompt() async{
    var sharedPreferences = NikkiSharedPreferences();
    await sharedPreferences.init();
    var newPrompt = await appConfig.fetchTestData();
    await sharedPreferences.setPrompt(newPrompt);
  }

   Future<String> loadUsername() async {
    var sharedPreferences = NikkiSharedPreferences();
    await sharedPreferences.init();
    username = sharedPreferences.getUsername();
    return username.isNotEmpty? username : "";
  }

  Future<void> addUsername(String newUsername) async{
    var sharedPreferences = NikkiSharedPreferences();
    await sharedPreferences.init();
    await sharedPreferences.setUsername(newUsername);
    this.username = newUsername;
  }

  Future<void> addDiaryEntry(DiaryEntryData diaryEntryData) async {
    personalEntries.add(diaryEntryData);
    diaryEntry = diaryEntryData;
    try {
      await _database.putDiaryEntry(diaryEntryData);
    } catch (e) {
      print(e);
      print("Couldn't write to database");
    }
  }

  Future<void> loadDiaryEntries() async {
    try {
      personalEntries = await _database.getDiaryEntries();
    } catch (e) {
      print("Couldn't load from database");
      print(e);
    }
  }

  Future<void> loadTodayEntry() async{
    if(personalEntries.isEmpty){
      await loadDiaryEntries();
    }
    var currentDay = DateTime.now();
    var todayEntry = personalEntries.indexWhere((element) =>
       element.dateTime.day == currentDay.day
        && element.dateTime.month == currentDay.month
        && element.dateTime.year == currentDay.year
    );
    if(todayEntry != null) {
      diaryEntry = personalEntries[todayEntry];
    }
  }

   Future<void> addSharedEntry(DiaryEntryData diaryEntryData) async {
     sharedEntries.add(diaryEntryData);
     try {
       await _database.putSharedEntry(diaryEntryData);
     } catch (e) {
       print(e);
       print("Couldn't write to database");
     }
   }

  Future<void> loadSharedEntries() async{
    try {
      sharedEntries = await _database.getSharedEntries();
    } catch (e) {
      print("Couldn't load from database");
      print(e);
    }
  }
}