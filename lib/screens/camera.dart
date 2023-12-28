import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/bloc/diary_entry_cubit.dart';
import 'package:nikki_app/utils/camera_util.dart';
import 'package:nikki_app/widgets/diary_entry.dart';
import 'package:nikki_app/widgets/nikki_title.dart';

import '../domain/repository/user_repository.dart';
import '../widgets/error_page.dart';
import '../widgets/loading_page.dart';
import '../widgets/no_entry_taken.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  DiaryEntryDetailsWidget? diaryEntryWidget;
  File? latestImage;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiaryEntryCubit>();

    void onSubmit() async {
      Navigator.of(context).pop();
      var description = textEditingController.text;
      if (description.isNotEmpty) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          var diaryEntry = DiaryEntryData("test_user", DateTime.now(),
              textEditingController.text, latestImage, position);
          bloc.addDiaryEntry(diaryEntry);
          setState(() {});
          //push to database
        }).catchError((e) {
          debugPrint(e);
        });
      }
    }

    Future openDialog() => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const NikkiTitle(content: "Description"),
              content: TextField(
                autocorrect: true,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: "Enter the description..."),
                controller: textEditingController,
              ),
              actions: [
                TextButton(
                    onPressed: onSubmit, child: const NikkiTitle(content: "Submit"))
              ],
            )
    );

    takeEntry() {
      CameraUtil().pick(onPick: (File? image) async {
        latestImage = image;
        openDialog();
      });
    }

    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              const NikkiTitle(content: "Welcome to your Nikki"),
              const Divider(),
              const Text("Your recent memories"),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  takeEntry();
                },
                child: const Text("Press me"),
              ),
              FutureBuilder<UserRepository>(
                future: context.read<DiaryEntryCubit>().loadData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  } else if (snapshot.hasError) {
                    return const ErrorPage(content: "No content loaded");
                  } else {
                    final userRepository = snapshot.data!;
                    if (userRepository.diaryEntry != null) {
                      return Column(
                        children: [
                          const NikkiTitle(content: "Today's Nikki"),
                          Center(
                            child: DiaryEntryDetailsWidget(
                                diaryEntry: userRepository.diaryEntry!),
                          ),
                        ],
                      );
                    }
                    return const NoEntryTakenWidget();
                  }
                },
              )
            ]),
          )),
    );
  }
}
