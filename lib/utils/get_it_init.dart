import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nikki_app/db/hive_background_service.dart';
import 'package:nikki_app/db/isar_database.dart';
import 'package:get_it/get_it.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';

import '../db/hive_database.dart';
import '../db/nikki_shared_pref.dart';

final getIt = GetIt.instance;

class GetItInitialization {
  setupGetIt() async {
    //getIt.registerLazySingleton(() => Dio());
    getIt.registerSingleton(() => NikkiSharedPreferences.init());
    getIt.registerLazySingleton(() => UserRepository());
    getIt.registerLazySingleton(() => Hive.initFlutter());
    getIt.registerLazySingleton(() => AppDatabase());
    getIt.registerFactory(() => HiveBackgroundService());
  }
}