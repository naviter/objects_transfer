// ignore_for_file: prefer_const_declarations

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // System configuration
  service.on("stop").listen((_) {
    service.stopSelf();
    print("background process is now stopped");
  });

  service.on("command_text").listen((_) {
    //* Experiment with this
    final message = "Service -> UI command";
    IsolateNameServer.lookupPortByName("ui")?.send(message);
  });

  service.on("command_object").listen((_) {
    //* Experiment with this
    final message = MyClass(123);
    IsolateNameServer.lookupPortByName("ui")?.send(message);
  });

  print("Service started");

  // Custom communication
  final serviceReceivePort = ReceivePort("service");
  IsolateNameServer.registerPortWithName(serviceReceivePort.sendPort, "service");

  serviceReceivePort.listen((message) async {
    print("🔶 Received message '$message' in service");
  });

  Timer.periodic(const Duration(seconds: 10), (timer) {
    print("Keepalive in foreground service: ${DateTime.now()}");
  });
}

class MyClass {
  final int x;
  MyClass(this.x);
}