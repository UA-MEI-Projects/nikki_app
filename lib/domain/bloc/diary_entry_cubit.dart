import 'package:bloc/bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';


class DiaryEntryCubit extends Cubit<UserRepository> {
  final UserRepository userRepository;

  DiaryEntryCubit(this.userRepository) : super(userRepository);

  Future<UserRepository> loadData() async {
    await userRepository.loadDiaryEntries();

    return userRepository;
  }

  Future<UserRepository> addDiaryEntry(DiaryEntryData diaryEntryData) async{
    await userRepository.addDiaryEntry(diaryEntryData);
    return userRepository;
  }
}
