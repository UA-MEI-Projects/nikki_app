import 'package:bloc/bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';

import '../../utils/get_it_init.dart';

class CameraCubit extends Cubit<UserRepository> {
  final UserRepository userRepository;

  CameraCubit(this.userRepository) : super(userRepository);

  Stream<UserRepository> get userStream => stream;

  Future<void> loadUserData() async {
    //await load from Hive
    emit(userRepository);
  }

  Future<bool> addDiaryEntry(DiaryEntryData diaryEntryData) async{
    await userRepository.addDiaryEntry(diaryEntryData);
    emit(userRepository);
    return true;
  }
}
