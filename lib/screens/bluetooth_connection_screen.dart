
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothConnectionWidget extends StatefulWidget{
  const BluetoothConnectionWidget({super.key});

  @override
  State<StatefulWidget> createState()  => _BluetoothConnectionWidget();

}

class _BluetoothConnectionWidget extends State<BluetoothConnectionWidget>{
  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {};
  bool permissionGranted = false;

  @override
  Widget build(BuildContext context) {

    [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request();

    return Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(content: "Searching for users...",),
      ),
      body: ListView(
        children: <Widget>[
          Text("User Name: $userName"),
          Wrap(
            children: <Widget>[
              ElevatedButton(
                child: const Text("Start Advertising"),
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
                            "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
                        setState(() {
                          endpointMap.remove(id);
                        });
                      },
                    );
                    showSnackbar("ADVERTISING: $a");
                  } catch (exception) {
                    showSnackbar(exception);
                  }
                },
              ),
              ElevatedButton(
                child: const Text("Stop Advertising"),
                onPressed: () async {
                  await Nearby().stopAdvertising();
                },
              ),
            ],
          ),
          Wrap(
            children: <Widget>[
              ElevatedButton(
                child: const Text("Start Discovery"),
                onPressed: () async {
                  try {
                    bool a = await Nearby().startDiscovery(
                      userName,
                      strategy,
                      onEndpointFound: (id, name, serviceId) {
                        // show sheet automatically to request connection
                        showModalBottomSheet(
                          context: context,
                          builder: (builder) {
                            return Center(
                              child: Column(
                                children: <Widget>[
                                  Text("id: $id"),
                                  Text("Name: $name"),
                                  Text("ServiceId: $serviceId"),
                                  ElevatedButton(
                                    child: const Text("Request Connection"),
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
                                ],
                              ),
                            );
                          },
                        );
                      },
                      onEndpointLost: (id) {
                        showSnackbar(
                            "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id");
                      },
                    );
                    showSnackbar("DISCOVERING: $a");
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
              ElevatedButton(
                child: const Text("Stop Discovery"),
                onPressed: () async {
                  await Nearby().stopDiscovery();
                },
              ),
            ],
          ),
          Text("Number of connected devices: ${endpointMap.length}"),
          ElevatedButton(
            child: const Text("Stop All Endpoints"),
            onPressed: () async {
              await Nearby().stopAllEndpoints();
              setState(() {
                endpointMap.clear();
              });
            },
          ),
          const Divider(),
          const Text(
            "Sending Data",
          ),
          ElevatedButton(
            child: const Text("Send Random Bytes Payload"),
            onPressed: () async {
              endpointMap.forEach((key, value) {
                String a = Random().nextInt(100).toString();

                showSnackbar("Sending $a to ${value.endpointName}, id: $key");
                Nearby()
                    .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
              });
            },
          ),
          ElevatedButton(
            child: const Text("Send File Payload"),
            onPressed: () async {
              XFile? file =
              await ImagePicker().pickImage(source: ImageSource.gallery);

              if (file == null) return;

              for (MapEntry<String, ConnectionInfo> m
              in endpointMap.entries) {
                int payloadId =
                await Nearby().sendFilePayload(m.key, file.path);
                showSnackbar("Sending file to ${m.key}");
                Nearby().sendBytesPayload(
                    m.key,
                    Uint8List.fromList(
                        "$payloadId:${file.path.split('/').last}".codeUnits));
              }
            },
          ),
          ElevatedButton(
            child: const Text("Print file names."),
            onPressed: () async {
              final dir = (await getExternalStorageDirectory())!;
              final files = (await dir.list(recursive: true).toList())
                  .map((f) => f.path)
                  .toList()
                  .join('\n');
              showSnackbar(files);
            },
          ),
        ],
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
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
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: $id"),
              Text("Token: ${info.authenticationToken}"),
              Text("Name${info.endpointName}"),
              Text("Incoming: ${info.isIncomingConnection}"),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    endpointMap[id] = info;
                  });
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes!);
                        showSnackbar("$endid: $str");

                        if (str.contains(':')) {
                          // used for file payload as file payload is mapped as
                          // payloadId:filename
                          int payloadId = int.parse(str.split(':')[0]);
                          String fileName = (str.split(':')[1]);

                          if (map.containsKey(payloadId)) {
                            if (tempFileUri != null) {
                              moveFile(tempFileUri!, fileName);
                            } else {
                              showSnackbar("File doesn't exist");
                            }
                          } else {
                            //add to map if not already
                            map[payloadId] = fileName;
                          }
                        }
                      } else if (payload.type == PayloadType.FILE) {
                        showSnackbar("$endid: File transfer started");
                        tempFileUri = payload.uri;
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar("$endid: FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

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
              ElevatedButton(
                child: const Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

