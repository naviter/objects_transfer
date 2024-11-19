import 'package:flutter_background_service/flutter_background_service.dart';

import 'channel.dart';
import 'isolate_entry_point.dart';

class FlutterBackgroundServiceChannel extends Channel {
  @override
  Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: _onStart,
        // onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: _onStart,
        isForegroundMode: true,
        autoStartOnBoot: false,
      ),
    );
  }
}

Future<void> _onStart(ServiceInstance service) async {
  isolateEntryPoint(null);
}