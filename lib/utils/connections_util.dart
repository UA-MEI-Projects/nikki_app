import 'dart:io';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../data/diary_entry.dart';

import 'dart:convert';

String serializeDiaryEntry(DiaryEntryData entry) {
  final Map<String, dynamic> entryMap = {
    'username': entry.username,
    'description': entry.description,
    'datetime': entry.dateTime.toIso8601String(),
    'image': entry.image != null ? base64Encode(entry.image!.readAsBytesSync()) : null,
    'longitude': entry.location.longitude,
    'latitude': entry.location.latitude
    // Add other fields as needed
  };

  return jsonEncode(entryMap);
}

DiaryEntryData deserializeDiaryEntry(String jsonStr) {
  final Map<String, dynamic> entryMap = jsonDecode(jsonStr);
  final Uint8List? imageBytes = entryMap['image'] != null ? base64Decode(entryMap['image']) : null;

  return DiaryEntryData(
    entryMap['username'],
    DateTime.parse(entryMap['datetime']),
    entryMap['description'],
    imageBytes != null ? File.fromRawPath(imageBytes) : null,
      Position(
        latitude: entryMap['latitude'].latitude,
        longitude: entryMap['longitude'].longitude,
        timestamp: DateTime.parse(entryMap['datetime']),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      )
    // Add other fields as needed
  );
}


Future<void> sendDiaryEntryOverBluetooth(DiaryEntryData entry) async {
  final serializedData = serializeDiaryEntry(entry);
  final List<int> bytes = utf8.encode(serializedData); // Convert to UTF-8 bytes

  try {
    await Nearby().sendBytesPayload('endpointId', Uint8List.fromList(bytes));
    // Replace 'endpointId' with the actual ID of the nearby device
  } catch (e) {
    print('Error sending data: $e');
  }
}

Future<void> receiveDiaryEntryOverBluetooth() async {
  Nearby().onPayloadReceived.listen((payload) {
    if (payload.type == PayloadType.bytes) {
      final List<int> bytes = List.from(payload.bytes!);
      final String serializedData = utf8.decode(bytes);
      final DiaryEntryData receivedEntry = deserializeDiaryEntry(serializedData);
      // Handle the received DiaryEntry
    }
  });
}