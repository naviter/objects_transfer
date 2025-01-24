// ignore_for_file: prefer_const_constructors, prefer_const_declarations, unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'background_locator_channel.dart';
import 'channel.dart';
import 'flutter_background_service_channel.dart';
import 'flutter_isolate_channel.dart';
import 'isolate_channel.dart';
import 'my_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1));


  //! CHANGE CHANNEL AND BEHAVIOR HERE
  const behavior = PortExchangeBehavior.isolateNameServer;
  // const behavior = PortExchangeBehavior.directExchange;

  final channel = IsolateChannel(behavior);
  // final channel = FlutterIsolateChannel(behavior);
  // final channel = FlutterBackgroundServiceChannel();
  // final channel = BackgroundLocatorChannel();



  Timer.run(() async {
    while(true) {
      await delay(200);
      delaySync(200);
    }
  });

  await channel.init();
  runApp(MainApp(channel));
}


class MainApp extends StatelessWidget {
  const MainApp(this.channel, {super.key});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Objects transfer demonstrator'),

              //* Text
              FilledButton(
                onPressed: () => channel.send("PING"),
                child: Text("Send text"),
              ),

              //* Object
              FilledButton(
                onPressed: () => channel.send(MyClass()),
                child: Text("Send object"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

