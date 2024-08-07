
import 'package:flutter/material.dart';

class App extends StatefulWidget {

  final Widget? startScreen;
  final String initialRouteName;

  const App({super.key, this.startScreen, required this.initialRouteName});

  @override
  State createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(title: "VkID-Example",
      home: widget.initialRouteName.isNotEmpty ? null : widget.startScreen,
      initialRoute: widget.initialRouteName,
      debugShowCheckedModeBanner: false, showSemanticsDebugger: false,
    );
  }
}