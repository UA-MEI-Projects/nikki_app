
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';
import 'package:nikki_app/utils/connections_util.dart';
import 'package:nikki_app/widgets/diary_entry.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/diary_entry.dart';
import '../utils/get_it_init.dart';

class BluetoothConnectionWidget extends StatefulWidget{
  const BluetoothConnectionWidget({super.key});

  @override
  State<StatefulWidget> createState()  => _BluetoothConnectionWidget();

}

class _BluetoothConnectionWidget extends State<BluetoothConnectionWidget>{
  late String userName = "";
  final Strategy strategy = Strategy.P2P_STAR;
  final UserRepository userRepository = getIt.get<UserRepository>();
  Map<String, ConnectionInfo> endpointMap = {};

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {};
  Map<DiaryEntryData, bool> checkedValues = {};
  bool permissionGranted = false;
  bool connectedToUser = false;
  late DiaryEntryData? selectedEntry;

  @override
  void initState() {
    super.initState();
    loadUsername();
    selectedEntry = userRepository.personalEntries.isNotEmpty? userRepository.personalEntries[0] : null;
    for(final entry in userRepository.personalEntries){
      checkedValues[entry] = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    endpointMap.clear();
    connectedToUser = false;
    closeConnections();
  }

  Future<void> loadUsername() async {
    var loadedUsername = await userRepository.loadUsername();
    setState(() {
      userName = loadedUsername;
    });
  }

  closeConnections() async {
    await Nearby().stopAdvertising();
    await Nearby().stopAllEndpoints();
    await Nearby().stopDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.nearbyWifiDevices
    ].request();

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.deepOrange;
      }
      return Colors.orangeAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(content: "Searching for users...",),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            NikkiText(content: "User Name: $userName"),
            OutlinedButton(
              child: const Text("I want to send my entries!"),
              onPressed: () async {
                try {
                  bool a = await Nearby().startAdvertising(
                    userName,
                    strategy,
                    onConnectionInitiated: onConnectionInit,
                    onConnectionResult: (id, status) {
                      showSnackbar(status);
                    },
                    onDisconnected: (id) {
                      showSnackbar(
                          "Disconnected");
                      setState(() {
                        endpointMap.remove(id);
                      });
                    },
                  );
                  showSnackbar("Searching for someone...");
                } catch (exception) {
                  showSnackbar(exception);
                }
              },
            ),
            OutlinedButton(
              child: const Text("I want to receive entries!"),
              onPressed: () async {
                try {
                  bool a = await Nearby().startDiscovery(
                    userName,
                    strategy,
                    onEndpointFound: (id, name, serviceId) {
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return Center(
                            child: OutlinedButton(
                              child: const NikkiText(content:"Request Connection"),
                              onPressed: () {
                                Navigator.pop(context);
                                Nearby().requestConnection(
                                  userName,
                                  id,
                                  onConnectionInitiated: (id, info) {
                                    onConnectionInit(id, info);
                                  },
                                  onConnectionResult: (id, status) {
                                    showSnackbar(status);
                                  },
                                  onDisconnected: (id) {
                                    setState(() {
                                      endpointMap.remove(id);
                                    });
                                    showSnackbar(
                                        "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    onEndpointLost: (id) {
                      showSnackbar(
                          "Connection lost");
                    },
                  );
                  showSnackbar("Searching for someone...");
                } catch (e) {
                  showSnackbar(e);
                }
              },
            ),
            NikkiSubTitle(content: "Status: ${connectedToUser? "Connected" : "Disconnected"}"),
            if(connectedToUser)
              Column(
                children: [
                  const Divider(),
                  NikkiText(content:"You can only send one Nikki at a time"),
                  SingleChildScrollView(
                    child: Column(
                      children: userRepository.personalEntries.map(
                          (e) =>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(),
                                Checkbox(
                                  tristate: true,
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                  value: checkedValues[e],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkedValues[e] = value ?? false;
                                      selectedEntry = e;
                                    });
                                  },
                                ),
                                Spacer(),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                    child: DiaryEntryShareWidget(diaryEntry: e)),
                                Spacer(),
                              ],
                            )
                      ).toList(),
                    ),
                  ),
                  OutlinedButton(
                    child: const NikkiText(content:"Send Diary Entry"),
                    onPressed: () async {
                      if(selectedEntry != null){
                        endpointMap.forEach((key, value) async {
                          showSnackbar("Sending your Nikki...");
                          sendDiaryEntryOverBluetooth(selectedEntry!, key);
                        });
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromRGBO(232, 100, 78, 0.8274509803921568),
      content: NikkiText(content:a.toString()),
    ));
  }

  Future<bool> moveFile(String uri, String fileName) async {
    String parentDir = (await getExternalStorageDirectory())!.absolute.path;
    final b =
    await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:$b");
    return b;
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: <Widget>[
                NikkiText(content: "${info.endpointName} wants to share their entries with you!"),
                OutlinedButton(
                  child: const NikkiText(content:"Accept Connection"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      endpointMap[id] = info;
                      connectedToUser = true;
                    });
                    Nearby().acceptConnection(
                      id,
                      onPayLoadRecieved: (endid, payload) async {
                        if (payload.type == PayloadType.BYTES) {
                          final result = await receiveDiaryEntryOverBluetooth(payload);
                          showSnackbar("Received a Nikki from "+result.username);
                        }
                      },
                      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                        if (payloadTransferUpdate.status ==
                            PayloadStatus.IN_PROGRESS) {
                          print(payloadTransferUpdate.bytesTransferred);
                        } else if (payloadTransferUpdate.status ==
                            PayloadStatus.FAILURE) {
                          showSnackbar("$endid: FAILED to transfer file");
                        } else if (payloadTransferUpdate.status ==
                            PayloadStatus.SUCCESS) {
                          if (map.containsKey(payloadTransferUpdate.id)) {
                            //rename the file now
                            String name = map[payloadTransferUpdate.id]!;
                            moveFile(tempFileUri!, name);
                          } else {
                            //bytes not received till yet
                            map[payloadTransferUpdate.id] = "";
                          }
                        }
                      },
                    );
                  },
                ),
                OutlinedButton(
                  child: const NikkiText(content:"Reject Connection"),
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      await Nearby().rejectConnection(id);
                    } catch (e) {
                      showSnackbar("Connection was not successful. Please try again later.");
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

