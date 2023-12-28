import 'package:hive/hive.dart';

//part 'diary_entries.g.dart';

@HiveType(typeId: 1)
class DiaryEntry {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? imagePath; // Store the path to the image

  @HiveField(4)
  final double latitude;

  @HiveField(5)
  final double longitude;

  DiaryEntry(this.username, this.dateTime, this.description, this.imagePath, this.longitude, this.latitude);
}