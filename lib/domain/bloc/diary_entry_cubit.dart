import 'package:bloc/bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';


class DiaryEntryCubit extends Cubit<UserRepository> {
  final UserRepository userRepository;

  DiaryEntryCubit(this.userRepository) : super(userRepository);

  Future<String> loadUsername() async {
    await userRepository.loadUsername();

    return userRepository.username;
  }

  Future<UserRepository> loadData() async {
    await Future.delayed(const Duration(seconds: 1), (){
      userRepository.loadDiaryEntries();
    });

    return userRepository;
  }

  Future<List<DiaryEntryData>> loadDiaryEntries() async{
    await Future.delayed(const Duration(seconds: 1), (){
      userRepository.loadDiaryEntries();
    });

    return userRepository.personalEntries;
  }

  Future<DiaryEntryData?> loadTodayEntry() async{
    await Future.delayed(const Duration(seconds: 2), (){
      userRepository.loadTodayEntry();
    });
    return userRepository.diaryEntry;
  }

  Future<List<DiaryEntryData>> loadSharedEntries() async{
    await Future.delayed(const Duration(seconds: 1), (){
      userRepository.loadDiaryEntries();
    });

    return userRepository.sharedEntries;
  }

  Future<UserRepository> addDiaryEntry(DiaryEntryData diaryEntryData) async{
    await userRepository.addDiaryEntry(diaryEntryData);
    return userRepository;
  }
}
