// ignore_for_file: prefer_const_declarations

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/location_dto.dart';
import 'package:location_permissions/location_permissions.dart';

@pragma('vm:entry-point')
void locationUpdateCallback(LocationDto locationDto) {
  print("locationUpdateCallback");
}

@pragma('vm:entry-point')
Future<void> serviceIsolateEntryPoint(dynamic _) async {
  // System configuration
  // service.on("stop").listen((_) {
  //   service.stopSelf();
  //   print("background process is now stopped");
  // });

  // service.on("command").listen((_) {
  //   //* Experiment with this
  //   // final message = "Service -> UI command";
  //   final message = MyClass(123);

  //   final uiSendPort = IsolateNameServer.lookupPortByName("ui");
  //   uiSendPort?.send(message);
  // });

  print("Background locator service started");

  // Custom communication
  final serviceReceivePort = ReceivePort("blservice");
  IsolateNameServer.registerPortWithName(serviceReceivePort.sendPort, "blservice");

  serviceReceivePort.listen((message) async {
    print("🔶 Received message '$message' in blservice");

    if (message == "command") {
      final message = MyBL2Class(123);

      final uiSendPort = IsolateNameServer.lookupPortByName("blui");
      uiSendPort?.send(message);
    }
  });

  Timer.periodic(const Duration(seconds: 1), (timer) {
    print("Keepalive in blservice: ${DateTime.now()}");
  });
}

class MyBL2Class {
  final int x;
  MyBL2Class(this.x);
}

void notificationTapCallback() {
  print("Notification tap");
}

Future<bool> checkLocationPermission() async {
  final access = await LocationPermissions().checkPermissionStatus();
  switch (access) {
    case PermissionStatus.unknown:
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
      final permission = await LocationPermissions().requestPermissions(
        permissionLevel: LocationPermissionLevel.locationAlways,
      );
      if (permission == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
      break;
    case PermissionStatus.granted:
      return true;
      break;
    default:
      return false;
      break;
  }
}
