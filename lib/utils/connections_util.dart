import 'dart:io';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../data/diary_entry.dart';

import 'dart:convert';

import 'get_it_init.dart';

final nearbyConnections = getIt.get<Nearby>();
final userRepository = getIt.get<UserRepository>();

String serializeDiaryEntry(DiaryEntryData entry) {
  final Map<String, dynamic> entryMap = {
    'username': entry.username,
    'prompt': entry.prompt,
    'description': entry.description,
    'datetime': entry.dateTime.toIso8601String(),
    'longitude': entry.location.longitude,
    'latitude': entry.location.latitude
    // Add other fields as needed
  };

  return jsonEncode(entryMap);
}


Future<DiaryEntryData> deserializeDiaryEntry(String jsonStr) async {
  final Map<String, dynamic> entryMap = jsonDecode(jsonStr);

  return DiaryEntryData(
      entryMap['username'],
      entryMap['prompt'],
      DateTime.parse(entryMap['datetime']),
      entryMap['description'],
      null,
      Position(
        latitude: entryMap['latitude'],
        longitude: entryMap['longitude'],
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



Future<void> sendDiaryEntryOverBluetooth(DiaryEntryData entry, String id) async {
  final serializedData = serializeDiaryEntry(entry); // Convert to UTF-8 bytes

  Nearby().sendBytesPayload(id, Uint8List.fromList(serializedData.codeUnits));
}

Future<DiaryEntryData> receiveDiaryEntryOverBluetooth(Payload payload) async {
  final List<int> bytes = List.from(payload.bytes!);
  final String serializedData = utf8.decode(bytes);
  final DiaryEntryData receivedEntry = await deserializeDiaryEntry(serializedData);
  userRepository.addSharedEntry(receivedEntry);
  return receivedEntry;
}

