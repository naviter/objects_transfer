// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'service.dart';
import 'service_with_background_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(Duration(seconds: 5));

  // Configure communication
  final uiReceivePort = ReceivePort("ui");
  IsolateNameServer.registerPortWithName(uiReceivePort.sendPort, "ui");

  uiReceivePort.listen((message) async {
    print("🔷 Received message '$message' in UI");
  });

  await initializeService();
  await initializeBackgroundLocatorService();
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

Future<void> initializeBackgroundLocatorService() async {
  final uiReceivePort2 = ReceivePort("blui");

  await checkLocationPermission();

  if (IsolateNameServer.lookupPortByName("blui") != null) {
    IsolateNameServer.removePortNameMapping("blui");
  }

  IsolateNameServer.registerPortWithName(uiReceivePort2.sendPort, "blui");

  uiReceivePort2.listen(
    (dynamic data) async {
      print("BL received in ui: $data");
    },
  );

  await BackgroundLocator.initialize();

  var isRunning = await BackgroundLocator.isServiceRunning();
  print('Running ${isRunning.toString()}');

  await BackgroundLocator.registerLocationUpdate(
    locationUpdateCallback,
    initCallback: serviceIsolateEntryPoint,
    androidSettings: AndroidSettings(
      client: LocationClient.android,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationTitle: "SeeYou Navigator",
        notificationMsg: "SeeYou Navigator is running",
        notificationBigMsg: "The app is recording flights",
        notificationTapCallback: notificationTapCallback,
      ),
      interval: 0,
      wakeLockTime: 60 * 24, // 24 hours
    ),
    iosSettings: IOSSettings(
      showsBackgroundLocationIndicator: true,
      accuracy: LocationAccuracy.HIGH,
    ),
  );

  await Future.delayed(Duration(seconds: 5));

  isRunning = await BackgroundLocator.isServiceRunning();
  print('Running ${isRunning.toString()}');
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
                onPressed: () {
                  FlutterBackgroundService().invoke("command");
                  IsolateNameServer.lookupPortByName("blservice")?.send("command");
                },
                child: Text("Execute command in service"),
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () => send(MyClass(123)),
                child: Text("Send text to port"),
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () => send(MyClass(123)),
                child: Text("Send object to port"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Experiment with this
  void send(Object message) {
    var serviceSendPort = IsolateNameServer.lookupPortByName("service");
    serviceSendPort?.send(message);

    serviceSendPort = IsolateNameServer.lookupPortByName("blservice");
    serviceSendPort?.send(MyBL2Class(123));
  }
}
