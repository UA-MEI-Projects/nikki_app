import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/bloc/diary_entry_cubit.dart';
import 'package:nikki_app/utils/camera_util.dart';
import 'package:nikki_app/widgets/diary_entry.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:nikki_app/widgets/splash_page.dart';

import '../config/app_config.dart';
import '../domain/repository/user_repository.dart';
import '../utils/get_it_init.dart';
import '../widgets/error_page.dart';
import '../widgets/loading_page.dart';

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
      var prompt = await bloc.userRepository.loadPrompt();
      if (description.isNotEmpty) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          var userRepository = bloc.userRepository;
          var diaryEntry = DiaryEntryData(
              userRepository.username,
              prompt,
              DateTime.now(),
              textEditingController.text,
              latestImage,
              position);
          bloc.addDiaryEntry(diaryEntry);
          setState(() {});
        }).catchError((e) {
          debugPrint(e);
        });
      }
    }

    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    onPressed: onSubmit,
                    child: const NikkiText(content: "Submit"))
              ],
            ));

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
              Container(
                  margin: EdgeInsets.all(
                      10), // Optional: to provide external spacing
                  padding: EdgeInsets.all(
                      10), // Optional: to provide internal spacing
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // Choose the container's background color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.deepOrangeAccent, // Border color
                      width: 1, // Border width
                    ), // Adjust for desired border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      NikkiSubTitle(content: "Your prompt for today!"),
                      FutureBuilder<String>(
                          future: getIt.get<UserRepository>().loadPrompt(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const TransparentLoadingPage();
                            } else if (snapshot.hasError) {
                              return const ErrorPage(
                                  content: "No content loaded");
                            } else if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.requireData.isNotEmpty) {
                              return NikkiText(content: snapshot.requireData);
                            }
                            return const NoPromptWidget();
                          })
                    ],
                  )),
              const Divider(),
              Container(
                margin:
                    EdgeInsets.all(10), // Optional: to provide external spacing
                padding:
                    EdgeInsets.all(10), // Optional: to provide internal spacing
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Choose the container's background color
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepOrangeAccent, // Border color
                    width: 1, // Border width
                  ), // Adjust for desired border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const NikkiSubTitle(content: "Your recent memories"),
                    const Divider(),
                    FutureBuilder<List<DiaryEntryData>>(
                      future: bloc.loadDiaryEntries(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TransparentLoadingPage();
                        } else if (snapshot.hasError) {
                          return const ErrorPage(content: "No content loaded");
                        } else if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.requireData.isNotEmpty) {
                          final entries = snapshot.requireData;
                          return DiaryEntryListPreviewWidget(entries: entries);
                        }
                        return const NoDiaryEntriesWidget();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Choose the container's background color
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepOrangeAccent, // Border color
                    width: 1, // Border width
                  ), // Adjust for desired border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const NikkiSubTitle(content: "Today's Nikki"),
                    const Divider(),
                    FutureBuilder<DiaryEntryData?>(
                      future: bloc.loadTodayEntry(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TransparentLoadingPage();
                        } else if (snapshot.hasError) {
                          return const ErrorPage(content: "No content loaded");
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final entry = snapshot.requireData;
                          if (entry != null)
                            return Column(
                              children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Center(
                                      child: DiaryEntryDetailsWidget(
                                          diaryEntry: entry),
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    takeEntry();
                                  },
                                  child: const NikkiText(content:"Take another Nikki"),
                                )
                              ],
                            );
                        }
                        return NoEntryTakenWidget(
                          takeEntry: takeEntry,
                        );
                      },
                    )
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
