import 'package:flutter/material.dart';
import 'package:nikki_app/data/diary_entry.dart';
import 'package:nikki_app/screens/bluetooth_connection_screen.dart';
import 'package:nikki_app/widgets/nikki_title.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (Center(
          child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              textDirection: TextDirection.ltr,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [const BluetoothShareWidget(), SharedWithMeWidget()]),
        )),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const NikkiTitle(content: "Connect with other users"),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BluetoothConnectionWidget()));
          },
          icon: const Icon(Icons.refresh),
          iconSize: 80.0,
        )
      ],
    );
  }
}

class SharedWithMeWidget extends StatelessWidget {

  List<DiaryEntryData> sharedEntries = [];

  SharedWithMeWidget({super.key}); //substituir por partilhas partilhadas
  
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NikkiTitle(content: "Shared with Me"),
          //Future Builder que carrega todas as partilhas guardadas
          Column(
            children: [],
          )
        ],
      ),
    );
  }
}
