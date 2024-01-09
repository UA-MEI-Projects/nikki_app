import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nikki_app/db/entities/diary_entries.dart';

import '../data/diary_entry.dart';
import 'database_adapter.dart';

class AppDatabase extends DatabaseAdapter {
  late final Box<DiaryEntry> diaryEntryBox;
  late final Box<DiaryEntry> sharedEntryBox;

  AppDatabase() {
    initHive();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DiaryEntryAdapter());
    openHiveBoxes();
  }

  Future<void> openHiveBoxes() async {
    diaryEntryBox = await Hive.openBox<DiaryEntry>('diary_entries');
    sharedEntryBox = await Hive.openBox<DiaryEntry>('shared_entries');
  }

  Future<void> putDiaryEntry(DiaryEntryData diaryEntryData) async {
    final diaryEntry = DiaryEntry(
        diaryEntryData.username,
        diaryEntryData.dateTime,
        diaryEntryData.description,
        diaryEntryData.image!.path,
        diaryEntryData.location.longitude,
        diaryEntryData.location.latitude,
        diaryEntryData.prompt);
    await diaryEntryBox.put(diaryEntry.hashCode, diaryEntry);
    print("Successfully written to database");
  }

  Future<List<DiaryEntryData>> getDiaryEntries() async {
    final List<DiaryEntry> result = await diaryEntryBox.values.toList();
    var entries = result.map((element) {
      return DiaryEntryData(
          element.username,
          element.prompt,
          element.dateTime,
          element.description,
          File(element.imagePath!),
          Position(
            latitude: element.latitude,
            longitude: element.longitude,
            timestamp: element.dateTime,
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ));
    }).toList();

    return entries;
  }

  Future<void> putSharedEntry(DiaryEntryData diaryEntryData) async {
    final diaryEntry = DiaryEntry(
        diaryEntryData.username,
        diaryEntryData.dateTime,
        diaryEntryData.description,
        null,
        diaryEntryData.location.longitude,
        diaryEntryData.location.latitude,
        diaryEntryData.prompt);
    await sharedEntryBox.put(diaryEntry.hashCode, diaryEntry);
    print("Successfully written to database");
  }

  Future<List<DiaryEntryData>> getSharedEntries() async {
    final List<DiaryEntry> result = await sharedEntryBox.values.toList();
    var entries = result.map((element) {
      return DiaryEntryData(
          element.username,
          element.prompt,
          element.dateTime,
          element.description,
          null,
          Position(
            latitude: element.latitude,
            longitude: element.longitude,
            timestamp: element.dateTime,
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ));
    }).toList();

    return entries;
  }
}

