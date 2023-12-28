import 'package:dio/dio.dart';
import 'package:nikki_app/db/hive_background_service.dart';
import 'package:get_it/get_it.dart';
import 'package:nikki_app/domain/bloc/preferences_cubit.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';

import '../db/hive_database.dart';
import '../db/nikki_shared_pref.dart';
import '../domain/bloc/diary_entry_cubit.dart';

final getIt = GetIt.instance;

class GetItInitialization {
  setupGetIt() async {
    getIt.registerSingleton(() => NikkiSharedPreferences.init());
    getIt.registerLazySingleton(() => Dio());
    //getIt.registerLazySingleton(() => AppDatabase());
    getIt.registerLazySingleton(() => UserRepository());
    getIt.registerLazySingleton(() => DiaryEntryCubit(getIt.get<UserRepository>()));
    getIt.registerFactory(() => PreferencesCubit(getIt.get<NikkiSharedPreferences>()));
    getIt.registerFactory(() => HiveBackgroundService());
  }
}