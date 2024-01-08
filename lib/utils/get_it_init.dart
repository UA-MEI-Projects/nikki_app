import 'package:dio/dio.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nikki_app/config/app_config.dart';
import 'package:nikki_app/db/hive_background_service.dart';
import 'package:get_it/get_it.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';

import '../db/hive_database.dart';
import '../db/nikki_shared_pref.dart';
import '../domain/bloc/diary_entry_cubit.dart';

final getIt = GetIt.instance;

class GetItInitialization {
  Future<void> setupGetIt() async {
    getIt.registerLazySingleton(() => Nearby());
    getIt.registerLazySingleton(() => AppDatabase());
    getIt.registerLazySingleton(() => UserRepository());
    getIt.registerLazySingleton(() => DiaryEntryCubit(getIt.get<UserRepository>()));
    getIt.registerLazySingleton(() => Dio());
    getIt.registerFactory(() => HiveBackgroundService());
  }
}