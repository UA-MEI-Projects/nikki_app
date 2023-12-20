// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart' as paths;
// import 'entities/user.dart';
//
// Future<Isar> openIsar() async {
//   final dir = await paths.getApplicationDocumentsDirectory();
//   final isar = await Isar.open(
//     [UserSchema, DiaryEntrySchema],
//     directory: dir.path,
//   );
//   return isar;
// }
//
// class AppDatabase {
//   late Future<Isar> isar;
//
//   AppDatabase(){
//     isar = openIsar();
//   }
//
//   /*Future<void> addUser(String username) async {
//     await isar.writeTxn(() async {
//        final newUser = User()
//           ..username = username;
//
//
//     });
//   }*/
// }
