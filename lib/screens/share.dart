import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/screens/bluetooth_connection_screen.dart';
import 'package:nikki_app/widgets/nikki_title.dart';

import '../domain/bloc/diary_entry_cubit.dart';
import '../widgets/diary_entry.dart';
import '../widgets/error_page.dart';
import '../widgets/loading_page.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(
          content: "Share your Nikki",
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: (Center(
              child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const BluetoothShareWidget(),
                    Divider(),
                    SharedWithMeWidget()
                  ]),
            )),
          ),
        ),
      ),
    );
  }
}

class BluetoothShareWidget extends StatelessWidget {
  const BluetoothShareWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10), // Optional: to provide external spacing
      padding: EdgeInsets.all(10), // Optional: to provide internal spacing
      decoration: BoxDecoration(
        color: Colors.white, // Choose the container's background color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.deepOrangeAccent, // Border color
          width: 1, // Border width
        ), // Adjust for desired border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Shadow color with opacity
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: Colors.white),
          const NikkiTitle(content: "Connect with other users"),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BluetoothConnectionWidget()));
            },
            icon: const Icon(Icons.refresh),
            iconSize: 80.0,
          ),
          NikkiText(content: "Find other users to share entries with.")
        ],
      ),
    );
  }
}

class SharedWithMeWidget extends StatelessWidget {
  List<DiaryEntryData> sharedEntries = [];

  SharedWithMeWidget({super.key}); //substituir por partilhas partilhadas

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiaryEntryCubit>();
    return Container(
      margin: EdgeInsets.all(10), // Optional: to provide external spacing
      padding: EdgeInsets.all(10), // Optional: to provide internal spacing
      decoration: BoxDecoration(
        color: Colors.white, // Choose the container's background color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.deepOrangeAccent, // Border color
          width: 1, // Border width
        ), // Adjust for desired border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Shadow color with opacity
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NikkiTitle(content: "Shared with Me"),
          FutureBuilder<List<DiaryEntryData>>(
              future: bloc.loadSharedEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const TransparentLoadingPage(); // Placeholder loading indicator
                } else if (snapshot.hasError) {
                  return ErrorPage(content: snapshot.error.toString());
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.requireData.isNotEmpty) {
                  final entries = snapshot.data!;
                  return Column(
                    children: entries
                        .map((e) => DiaryEntryWidget(diaryEntry: e))
                        .toList(),
                  );
                }
                return const NoSharedEntriesWidget();
              })
        ],
      ),
    );
  }
}
