

import 'package:flutter/material.dart';
import 'package:nikki_app/model/diary_entry.dart';

class DiaryEntryWidget extends StatefulWidget{
  final DiaryEntryData diaryEntry;

  const DiaryEntryWidget({super.key, required this.diaryEntry});
  @override
  State<StatefulWidget> createState() => _DiaryEntryState(diaryEntry: diaryEntry);
}

class _DiaryEntryState extends State<DiaryEntryWidget>{
  late bool expanded;
  final DiaryEntryData diaryEntry;

  _DiaryEntryState({required this.diaryEntry});

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  expandEntry(){
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.0),
    child: Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your entry at "+diaryEntry.dateTime.day.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.black54
                ),
              ),
              IconButton(onPressed: expandEntry, icon: Icon(Icons.arrow_drop_down_circle_rounded))
            ],
          ),
          if(expanded)
            DiaryEntryDetailsWidget(diaryEntry: diaryEntry)
        ],
      ),
    ));
  }
}

class DiaryEntryDetailsWidget extends StatelessWidget{
  final DiaryEntryData diaryEntry;
  const DiaryEntryDetailsWidget({super.key, required this.diaryEntry});


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Image.file(diaryEntry.image!),
          Text(
            diaryEntry.description,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

}