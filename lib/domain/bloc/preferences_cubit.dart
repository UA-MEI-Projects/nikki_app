import 'package:bloc/bloc.dart';
import 'package:nikki_app/db/nikki_shared_pref.dart';

class PreferencesCubit extends Cubit<NikkiSharedPreferences>{
  final NikkiSharedPreferences nikkiSharedPreferences;

  PreferencesCubit(this.nikkiSharedPreferences) : super(nikkiSharedPreferences);

}