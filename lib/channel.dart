import 'dart:isolate';
import 'dart:ui';

abstract class Channel {
  Channel([this.behavior = PortExchangeBehavior.isolateNameServer]) {
    print("💢 Behavior in UI: $behavior");

    if (behavior == PortExchangeBehavior.isolateNameServer) {
      IsolateNameServer.registerPortWithName(uiReceivePort.sendPort, "ui");
    }

    uiReceivePort.listen((message) async {
      print("🔷 Received message '$message' in UI");

      switch(message) {
        case (SendPort _) when behavior == PortExchangeBehavior.directExchange:
          _remoteSendPort = message;
          print("💨 Configured SendPort in UI");
      }
    });
  }

  final uiReceivePort = ReceivePort("ui");
  SendPort? _remoteSendPort;

  final PortExchangeBehavior behavior;

  Future<void> init();

  // Sends message from UI to isolate
  Future<void> send(dynamic message) async {
    print("▶ Sending message '$message' from UI");

    final port = _remoteSendPort ?? IsolateNameServer.lookupPortByName("isolate")!;
    port.send(message);
  }
}

enum PortExchangeBehavior {
  isolateNameServer,
  directExchange,
}