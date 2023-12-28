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

import '../domain/repository/user_repository.dart';
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
    final bloc = context.read<DiaryEntryCubit>();
    return (Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(content: "History"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Map"), Tab(text: "Calendar")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<UserRepository>(
            future: bloc.loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage(); // Placeholder loading indicator
              } else if (snapshot.hasError) {
                return ErrorPage(content: snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data != null) {
                final userRepository = snapshot.data;
                return Center(
                  child: MapWidget(
                      personalEntries: userRepository!.personalEntries),
                );
              } else {
                return const NoEntryTakenWidget();
              }
            },
          ),
          const CalendarWidget(),
        ],
      ),
    ));
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //CalendarDatePicker(initialDate: DateTime(), firstDate: DateTime(), lastDate: DateTime(), onDateChanged: (dateTime){})
      ],
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
              content: DiaryEntryDetailsWidget(diaryEntry: entry),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"))
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
