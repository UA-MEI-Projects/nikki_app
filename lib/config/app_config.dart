import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:nikki_app/api_key.dart';

import '../utils/get_it_init.dart';

class AppConfig {
  final String _baseUrl = 'https://drinking1.p.rapidapi.com/questions/random';

  List<String> questionsArray = [
    "What is your favorite color?",
    "If you could travel anywhere, where would you go?",
    "What is your dream job?",
    "If you could have any superpower, what would it be?",
    "What is your favorite book?",
    "If you could meet any historical figure, who would it be?",
    "What is your go-to comfort food?",
    "If you could time travel, which era would you visit?",
    "What is your favorite hobby?",
    "If you could learn any new skill, what would it be?",
  ];

  Future<String> fetchTestData() async {
    await Future.delayed(Duration(seconds: 2));
    Random random = Random();
    int randomIndex = random.nextInt(questionsArray.length);
    return questionsArray[randomIndex];
  }

  Future<String> fetchData() async {
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
        return data['text'];
        print("Random Drinking Question: "+data['text']);
      } else {
        print("Error: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      print("Error: $e");
    }

    return "Couldn't load prompt";
  }

}