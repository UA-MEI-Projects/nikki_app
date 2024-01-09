import 'dart:io';

import 'package:geolocator/geolocator.dart';

class DiaryEntryData{
  final String username;
  final String prompt;
  final DateTime dateTime;
  final String description;
  final File? image;
  final Position location;

  DiaryEntryData(this.username, this.prompt, this.dateTime, this.description, this.image, this.location);

  String dateToString(){
    return dateTime.day.toString() + "/" +
          dateTime.month.toString() + "/" +
         dateTime.year.toString() + " " +
        dateTime.hour.toString() + "h" +
        dateTime.minute.toString() + "m";

  }

  String dayToString(){
    return dateTime.day.toString() + "/" +
        dateTime.month.toString() + "/" +
        dateTime.year.toString();
  }
}