import 'package:flutter/cupertino.dart';
import 'package:nikki_app/data/diary_entry.dart';

class DiaryEntryModel extends ChangeNotifier{
  DiaryEntryData? _entry = null;

  //test api calls
  Future<DiaryEntryData?> fetchTodayEntry() async {
    return _entry;
  }

  void addEntry(DiaryEntryData entry){
    _entry = entry;
    notifyListeners();
  }

  void removeAll(){
    _entry = null;
    notifyListeners();
  }

}