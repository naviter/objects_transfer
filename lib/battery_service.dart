import 'dart:async';
import 'dart:io';

import 'package:battery_info_plugin/battery_info_plugin.dart';

/// Provides battery level updates once per 5 seconds and on battery status change. Convert to device? (like microphone)
class BatteryService {
  BatteryService() {
    Timer.periodic(const Duration(seconds: 5), (timer) => _update());
  }

  Future<void> _update() async {
    if (Platform.isAndroid) {
      final info = await BatteryInfoPlugin.getBatteryInfo();

      final level = info["batteryLevel"] as int;
      final voltage = (info["batteryVoltage"] as int) / 1000;
      final current = (info["batteryCurrentNow"] as int) / 1000;

      final power = (voltage * current).toStringAsFixed(0);
      print("${DateTime.now()}         $level%         ${power}mW");
    }
  }
}