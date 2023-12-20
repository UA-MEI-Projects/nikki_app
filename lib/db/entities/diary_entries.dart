import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';

part 'diary_entries.g.dart';

// @Collection()
// class DiaryEntry {
//   @Id()
//   int? id;
//
//   String? username;
//   String? description;
//   DateTime? datetime;
//   Uint8List? photo;
//   double? longitude;
//   double? latitude;
//
//   late String? photoBase64;
//
//   Uint8List? get photo {
//     return photoBase64 != null ? base64Decode(photoBase64!) : null;
//   }
// }

@HiveType(typeId: 0)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime datetime;

  @HiveField(3)
  late Uint8List? photo;

  @HiveField(4)
  late Position? location;

  DiaryEntry({required this.username, required this.description, required this.datetime, this.photo, this.location});
}