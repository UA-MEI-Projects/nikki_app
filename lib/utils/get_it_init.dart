import 'package:dio/dio.dart';
import 'package:nikki_app/db/drift_database.dart';
import 'package:get_it/get_it.dart';

import '../db/nikki_shared_pref.dart';

final getIt = GetIt.instance;

class GetItInitialization {
  void setupGetIt() {
    //getIt.registerLazySingleton(() => Dio());
    //getIt.registerLazySingleton(() => AppDatabase());
    getIt.registerLazySingleton(() => NikkiSharedPreferences.init());
  }
}