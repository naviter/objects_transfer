import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:location_permissions/location_permissions.dart';

import 'channel.dart';
import 'isolate_entry_point.dart';

class BackgroundLocatorChannel extends Channel {
  @override
  Future<void> init() async {
    await checkLocationPermission();
    await Future.delayed(const Duration(seconds: 1));
    await BackgroundLocator.initialize();
    await BackgroundLocator.registerLocationUpdate(
      _locationUpdateCallback,
      initCallback: isolateEntryPoint,
      androidSettings: const AndroidSettings(
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationTitle: "SeeYou Navigator",
          notificationMsg: "SeeYou Navigator is running",
          notificationBigMsg: "The app is recording flights",
          notificationTapCallback: _notificationTapCallback,
        ),
        interval: 0,
        wakeLockTime: 60 * 24, // 24 hours
      ),
      iosSettings: const IOSSettings(
        showsBackgroundLocationIndicator: true,
        accuracy: LocationAccuracy.HIGH,
      ),
    );
  }

  Future<bool> checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus(level: LocationPermissionLevel.locationAlways);
    return switch (access) {
      PermissionStatus.granted => true,

      PermissionStatus.unknown ||
      PermissionStatus.denied ||
      PermissionStatus.restricted => await LocationPermissions().requestPermissions(permissionLevel: LocationPermissionLevel.locationAlways) == PermissionStatus.granted,
    };
  }
}



@pragma('vm:entry-point')
void _locationUpdateCallback(LocationDto locationDto) {
  print("locationUpdateCallback");
}

void _notificationTapCallback() {
  print("Notification tap");
}


// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }