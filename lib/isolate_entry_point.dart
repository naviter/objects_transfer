import 'dart:isolate';
import 'dart:ui';

import 'package:objects_transfer/channel.dart';

import 'my_class.dart';

void isolateEntryPoint(dynamic parameter) {
  final behavior = parameter is SendPort ? PortExchangeBehavior.directExchange : PortExchangeBehavior.isolateNameServer;
  print("💢 Behavior in isolate: $behavior");

  final receivePort = ReceivePort();
  final remoteSendPort = switch(behavior) {
    PortExchangeBehavior.directExchange => parameter,
    PortExchangeBehavior.isolateNameServer => IsolateNameServer.lookupPortByName("ui")!,
  };

  Future<void> sendBack(dynamic obj) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("▶ Sending message '$obj' from isolate");
    remoteSendPort.send(obj);
  }

  receivePort.listen((message) {
    print("🔶 Received message '$message' in isolate");

    switch(message) {
      case (String _): sendBack("PONG");
      case (MyClass _): sendBack(MyClass());
    }
  });

  switch (behavior) {
    case PortExchangeBehavior.directExchange: sendBack(receivePort.sendPort);
    case PortExchangeBehavior.isolateNameServer: IsolateNameServer.registerPortWithName(receivePort.sendPort, "isolate");
  }
}