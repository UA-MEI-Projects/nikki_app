import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nikki_app/model/diary_entry.dart';
import 'package:nikki_app/screens/map.dart';
import 'package:nikki_app/utils/camera_util.dart';
import 'package:nikki_app/widgets/diary_entry.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:provider/provider.dart';

import '../model/diary_entry_model.dart';
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
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var diaryEntryModel = context.watch<DiaryEntryModel>();

    void onSubmit() async {
      Navigator.of(context).pop();
      var description = textEditingController.text;
      if(description != null && description.isNotEmpty){
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          var diaryEntry = DiaryEntryData("test_user", DateTime.now(),
              textEditingController.text, latestImage, position);
          diaryEntryModel.addEntry(diaryEntry);
        }).catchError((e) {
          debugPrint(e);
        });
      }
    }

    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: NikkiTitle(content: "Description"),
              content: TextField(
                autocorrect: true,
                autofocus: true,
                decoration:
                    InputDecoration(hintText: "Enter the description..."),
                controller: textEditingController,
              ),
              actions: [
                TextButton(
                    onPressed: onSubmit, child: NikkiTitle(content: "Submit"))
              ],
            ));

    takeEntry() {
      CameraUtil().pick(onPick: (File? image) async {
        setState(() {
          latestImage = image!;
        });
        openDialog();
      });
    }

    return SafeArea(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              NikkiTitle(content: "Welcome to your Nikki"),
              Divider(),
              Text("Your recent memories"),
              Divider(),
              ElevatedButton(
                onPressed: () {
                  takeEntry();
                },
                child: Text("Press me"),
              ),
              FutureBuilder<DiaryEntryData?>(
                future: diaryEntryModel.fetchTodayEntry(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage(); // Placeholder loading indicator
                  } else if (snapshot.hasError) {
                    return ErrorPage(content: snapshot.error.toString());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      children: [
                        NikkiTitle(content: "Today's Nikki"),
                        Center(
                          child: DiaryEntryDetailsWidget(diaryEntry: snapshot.data!,),
                        ),
                      ],
                    );
                  }
                  else {
                    return NoEntryTakenWidget();
                  }
                },
              )
            ]),
          )),
    );
  }
}
