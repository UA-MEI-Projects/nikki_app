import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/widgets/nikki_title.dart';

class DiaryEntryWidget extends StatefulWidget {
  final DiaryEntryData diaryEntry;

  const DiaryEntryWidget({super.key, required this.diaryEntry});
  @override
  State<StatefulWidget> createState() =>
      _DiaryEntryState(diaryEntry: diaryEntry);
}

class _DiaryEntryState extends State<DiaryEntryWidget> {
  late bool expanded;
  final DiaryEntryData diaryEntry;

  _DiaryEntryState({required this.diaryEntry});

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  expandEntry() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      NikkiText(content: diaryEntry.dayToString()),
                      NikkiText(content: diaryEntry.username)
                    ],
                  ),
                  IconButton(
                      onPressed: expandEntry,
                      icon: const Icon(Icons.arrow_drop_down_circle_rounded))
                ],
              ),
              if (expanded) DiaryEntryMapWidget(diaryEntry: diaryEntry)
            ],
          ),
        ));
  }
}

class DiaryEntryMapWidget extends StatelessWidget {
  final DiaryEntryData diaryEntry;
  const DiaryEntryMapWidget({super.key, required this.diaryEntry});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      shadowColor: Colors.grey,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    NikkiText(
                      content: diaryEntry.username,
                    ),
                    Spacer(),
                    NikkiText(
                      content: diaryEntry.dateToString(),
                    ),
                  ],
                ),
              ),
              NikkiSubTitle(content: diaryEntry.prompt),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                      center: LatLng(diaryEntry.location.latitude,
                          diaryEntry.location.longitude),
                      zoom: 12),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: LatLng(diaryEntry.location.latitude,
                                diaryEntry.location.longitude),
                            width: 200,
                            height: 200,
                            child: IconButton(
                              icon: const Icon(Icons.location_on),
                              onPressed: () {},
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
              NikkiText(
                content: diaryEntry.description,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DiaryEntryDetailsWidget extends StatelessWidget {
  final DiaryEntryData diaryEntry;
  const DiaryEntryDetailsWidget({super.key, required this.diaryEntry});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      shadowColor: Colors.grey,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    NikkiText(
                      content: diaryEntry.username,
                    ),
                    Spacer(),
                    NikkiText(
                      content: diaryEntry.dateToString(),
                    ),
                  ],
                ),
              ),
              NikkiSubTitle(content: diaryEntry.prompt),
              NikkiText(
                content: "Answer: "+diaryEntry.description,
              ),
              ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(
                    diaryEntry.image!,
                    scale: 0.6,
                    fit: BoxFit.fitWidth,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DiaryEntryDetailsDialogWidget extends StatelessWidget {
  final DiaryEntryData diaryEntry;
  const DiaryEntryDetailsDialogWidget({super.key, required this.diaryEntry});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      shadowColor: Colors.grey,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              NikkiText(
                content: diaryEntry.username,
              ),
              NikkiText(
                content: diaryEntry.dateToString(),
              ),
              NikkiSubTitle(content: diaryEntry.prompt),
              NikkiText(
                content: "Answer: "+diaryEntry.description,
              ),
              ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(
                    diaryEntry.image!,
                    height: MediaQuery.of(context).size.longestSide * 0.35,
                    scale: 0.6,
                    fit: BoxFit.fitWidth,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DiaryEntryListPreviewWidget extends StatelessWidget {
  final List<DiaryEntryData> entries;
  const DiaryEntryListPreviewWidget({super.key, required this.entries});

  List<DiaryEntryData> getLastThreeFromList() {
    return entries.reversed.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    openDialog(DiaryEntryData entry) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const NikkiTitle(content: "Your memories"),
              content:  SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: DiaryEntryDetailsDialogWidget(diaryEntry: entry)),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const NikkiText(content: "Close"))
              ],
            ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getLastThreeFromList()
          .map((e) => Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: GestureDetector(
                onTap: () => openDialog(e),
                child: DiaryEntryPreviewWidget(diaryEntry: e),
              )))
          .toList(),
    );
  }
}

class DiaryEntryPreviewWidget extends StatelessWidget {
  final DiaryEntryData diaryEntry;
  const DiaryEntryPreviewWidget({super.key, required this.diaryEntry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        child: SizedBox(
          width: 50,
          height: 100,
          child: Image.file(
            diaryEntry.image!,
            scale: 0.6,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class DiaryEntryShareWidget extends StatelessWidget {
  final DiaryEntryData diaryEntry;

  const DiaryEntryShareWidget({super.key, required this.diaryEntry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            NikkiText(content: diaryEntry.dateToString()),
            NikkiSubTitle(content: diaryEntry.prompt)
          ],
        ),
      ),
    );
  }
}
