import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nikki_app/model/diary_entry.dart';
import 'package:nikki_app/widgets/error_page.dart';
import 'package:nikki_app/widgets/loading_page.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:provider/provider.dart';

import '../model/diary_entry_model.dart';
import '../widgets/no_entry_taken.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    var diaryEntry = context.watch<DiaryEntryModel>();

    return (Scaffold(
      appBar: AppBar(
        title: NikkiTitle(content: "History"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Map"), Tab(text: "Calendar")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<DiaryEntryData?>(
            future: diaryEntry.fetchTodayEntry(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage(); // Placeholder loading indicator
              } else if (snapshot.hasError) {
                return ErrorPage(content: snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data != null) {
                return Center(
                  child: MapWidget(diaryEntry: snapshot.data!),
                );
              } else {
                return NoEntryTakenWidget();
              }
            },
          ),
          CalendarWidget(),
        ],
      ),
    ));
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //CalendarDatePicker(initialDate: DateTime(), firstDate: DateTime(), lastDate: DateTime(), onDateChanged: (dateTime){})
      ],
    );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({super.key, required this.diaryEntry});

  final DiaryEntryData diaryEntry;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: FlutterMap(
      options: MapOptions(
          center: LatLng(
              diaryEntry.location.latitude, diaryEntry.location.longitude),
          zoom: 12),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                )),
          ],
        ),
      ],
    ));
  }
}
