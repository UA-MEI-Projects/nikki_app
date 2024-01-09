import 'dart:async';
import 'dart:isolate';

class HiveBackgroundService {
  static void _backgroundEntryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      // Handle messages from the main isolate
      if (message is Function) {
        message();
      }
    });
  }

  late SendPort _sendPort;

  HiveBackgroundService() {
    _init();
  }

  Future<void> _init() async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_backgroundEntryPoint, receivePort.sendPort);
    _sendPort = await receivePort.first;
  }

  Future<void> executeInBackground(Function function) async {
    final responsePort = ReceivePort();
   // _sendPort.send(Function.apply(function, [], { '_responsePort': responsePort.sendPort}));
  }
}