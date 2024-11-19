import 'dart:isolate';

import 'channel.dart';
import 'isolate_entry_point.dart';

class IsolateChannel extends Channel {
  IsolateChannel(super.behavior);

  @override
  Future<void> init() async {
    await Isolate.spawn(isolateEntryPoint, behavior == PortExchangeBehavior.directExchange ? uiReceivePort.sendPort : null);
  }
}