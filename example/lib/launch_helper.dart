
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'ui/home_screen.dart';

abstract class LaunchHelper {

  static Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(size: Size(360, 640), minimumSize: Size(360, 640), maximumSize: Size(720, 1280), alwaysOnTop: false, fullScreen: false, backgroundColor: Colors.transparent, center: true, title: "VkID-Example");
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    runApp(const App(startScreen: HomeScreen(), initialRouteName: ""));
  }
}