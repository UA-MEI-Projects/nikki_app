import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nikki_app/api_key.dart';

import '../utils/get_it_init.dart';

class AppConfig {
  final String _baseUrl = 'https://drinking1.p.rapidapi.com/questions/random';

  Future<void> fetchData() async {
    try {
      Response response = await getIt.get<Dio>().get(
        _baseUrl,
        queryParameters: {"type": "funny"},
        options: Options(
          headers: {
            "X-RapidAPI-Host": "drinking1.p.rapidapi.com",
            "X-RapidAPI-Key": apiKey,
            "Content-Type": "application/json",
          },
        ),
      );

      // Handle the response
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        print("Random Drinking Question: "+data['text']);
      } else {
        print("Error: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

}