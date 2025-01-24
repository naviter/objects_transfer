class MyClass {
  MyClass() : x = 42;
  final int x;
}

void delaySync(int milliseconds) {
  final sw = Stopwatch()..start();
  while (sw.elapsedMilliseconds < milliseconds) {}
}

Future<void> delay(int milliseconds)
  => Future.delayed(Duration(milliseconds: milliseconds));
