import 'package:flutter/services.dart';

Future<void> lockPhoneOrientationVertical() async {
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}