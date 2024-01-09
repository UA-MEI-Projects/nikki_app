import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/domain/bloc/diary_entry_cubit.dart';
import 'package:nikki_app/widgets/diary_entry.dart';
import 'package:nikki_app/widgets/error_page.dart';
import 'package:nikki_app/widgets/loading_page.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  DiaryEntryData? selectedEntry = null;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectEntry(DiaryEntryData? diaryEntryData, DateTime dateTime){
    if(diaryEntryData != null){
      setState(() {
        selectedEntry = diaryEntryData;
        selectedDate = dateTime;
      });
    }
    else{
      setState(() {
        selectedEntry = null;
        selectedDate = dateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiaryEntryCubit>();
    return (Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(content: "History"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Map"), Tab(text: "Calendar")],
        ),
      ),
      body: FutureBuilder<List<DiaryEntryData>>(
          future: bloc.loadDiaryEntries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage(); // Placeholder loading indicator
            } else if (snapshot.hasError) {
              return ErrorPage(content: snapshot.error.toString());
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.requireData.isNotEmpty) {
              final entries = snapshot.requireData;
              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Center(
                    child: MapWidget(personalEntries: entries),
                  ),
                  CalendarWidget(personalEntries: entries, entry: selectedEntry, onSelect: selectEntry, dateSelected: selectedDate,),
                ],
              );
            }
            return const ErrorPage(content: "Something went wrong. Please try again later.");
          }),
    ));
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key, required this.personalEntries, required this.entry,required this.dateSelected, required this.onSelect});

  final List<DiaryEntryData> personalEntries;
  final DiaryEntryData? entry;
  final DateTime dateSelected;
  final void Function(DiaryEntryData?, DateTime) onSelect;

  DateTime findOldestEntry(){
    if (personalEntries.isEmpty) {
      return DateTime.now();
    }

    DiaryEntryData oldestEntry = personalEntries[0];

    for (var entry in personalEntries) {
      if (entry.dateTime.isBefore(oldestEntry.dateTime)) {
        oldestEntry = entry;
      }
    }
    return oldestEntry.dateTime;
  }

  DiaryEntryData? findEntryByDateTime(DateTime targetDateTime) {
    for (var entry in personalEntries) {
      if (entry.dateTime.day == targetDateTime.day
          && entry.dateTime.month == targetDateTime.month
          && entry.dateTime.year == targetDateTime.year) {
        return entry;
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CalendarDatePicker(
                initialDate: dateSelected,
                firstDate: findOldestEntry(),
                lastDate: DateTime.now(),
                onDateChanged: (dateTime) =>
                  onSelect(findEntryByDateTime(dateTime), dateTime)),
              if(entry != null)
                DiaryEntryDetailsWidget(diaryEntry: entry!)
          ],
        ),
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({super.key, required this.personalEntries});

  final List<DiaryEntryData> personalEntries;

  @override
  Widget build(BuildContext context) {
    Future openDialog(DiaryEntryData entry) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const NikkiTitle(content: "Your memories"),
              content: SingleChildScrollView(
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

    return Flexible(
        child: FlutterMap(
      options: MapOptions(
          center: LatLng(personalEntries.last.location.latitude,
              personalEntries.last.location.longitude),
          zoom: 12),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
            markers: personalEntries
                .map((entry) => Marker(
                    point: LatLng(
                        entry.location.latitude, entry.location.longitude),
                    width: 200,
                    height: 200,
                    child: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        openDialog(entry);
                      },
                    )))
                .toList()),
      ],
    ));
  }
}
