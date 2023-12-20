import 'package:bloc/bloc.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';

import '../../utils/get_it_init.dart';

class MapCubit extends Cubit<UserRepository> {
  final UserRepository userRepository;

  MapCubit(this.userRepository) : super(userRepository);


  Future<void> loadUserData() async {
    // Implement logic to load data from the repository
    // For example, userRepository.loadUsername(), userRepository.loadPersonalEntries(), etc.
    // Update state using emit(userRepository) when data is loaded
    emit(userRepository);
  }

// Add methods to update data when necessary
}
