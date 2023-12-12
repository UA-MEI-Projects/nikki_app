import 'package:dio/dio.dart';

import '../utils/get_it_init.dart';

class AppConfig {
  final String _baseUrl = '';

  Future<void> initializeDio() async {
    getIt.get<Dio>().options.baseUrl = _baseUrl;
  }
}