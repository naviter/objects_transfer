import 'channel.dart';
import 'isolate_entry_point.dart';

import 'package:flutter_isolate/flutter_isolate.dart';

class FlutterIsolateChannel extends Channel {
  FlutterIsolateChannel(super.behavior);

  @override
  Future<void> init() async {
    await FlutterIsolate.spawn(isolateEntryPoint, behavior == PortExchangeBehavior.directExchange ? uiReceivePort.sendPort : null);
  }
}