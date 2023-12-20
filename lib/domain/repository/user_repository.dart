import '../../data/diary_entry.dart';

class UserRepository {
   final String username = "default";
   List<DiaryEntryData> personalEntries = []; //load from db
   List<DiaryEntryData> sharedEntries = []; //load from db
   DiaryEntryData? diaryEntry = null;


   Future<String> loadUsername() async {
    // Simulate loading from a database or other source
    await Future.delayed(Duration(seconds: 2));
    return username;
  }

  Future<void> addDiaryEntry(DiaryEntryData diaryEntryData) async{
     try{
       personalEntries.add(diaryEntryData);
       diaryEntry = diaryEntryData;
     }catch(e){

     }
  }
}