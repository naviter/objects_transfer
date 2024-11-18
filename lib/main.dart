// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure communication
  final uiReceivePort = ReceivePort("ui");
  IsolateNameServer.registerPortWithName(uiReceivePort.sendPort, "ui");

  uiReceivePort.listen((message) async {
    print("🔷 Received message '$message' in UI");
  });

  await initializeService();
  runApp(const MainApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      // onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: false,
    ),
  );
}

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Foreground service demonstrator'),
              SizedBox(height: 16),

              FilledButton(
                onPressed: () => FlutterBackgroundService().startService(),
                child: Text("Start service"),
              ),
              SizedBox(height: 16),

              FilledButton(
                onPressed: () => FlutterBackgroundService().invoke("stop"),
                child: Text("Stop service"),
              ),
              SizedBox(height: 16),

              FilledButton(
                onPressed: ()=> FlutterBackgroundService().invoke("command_text"),
                child: Text("Send text from service"),
              ),
              SizedBox(height: 16),

              FilledButton(
                onPressed: ()=> FlutterBackgroundService().invoke("command_object"),
                child: Text("Send object from service"),
              ),
              SizedBox(height: 16),

              FilledButton(
                onPressed: () => send("TEXT"),
                child: Text("Send text to service"),
              ),
              SizedBox(height: 16),

              FilledButton(
                onPressed: () => send(MyClass(123)),
                child: Text("Send object to service"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Experiment with this
  void send(Object message) {
    final serviceSendPort = IsolateNameServer.lookupPortByName("service");
    serviceSendPort?.send(message);
  }
}