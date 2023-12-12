import 'dart:io';

import 'package:geolocator/geolocator.dart';

class DiaryEntryData{
  final String username;
  final DateTime dateTime;
  final String description;
  final File? image;
  final Position location;

  DiaryEntryData(this.username, this.dateTime, this.description, this.image, this.location);
}