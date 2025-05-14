
///Dart-level release flag according flutter doc https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
// ignore: do_not_use_environment
const kDartReleaseMode = bool.fromEnvironment("dart.vm.product", defaultValue: false);
///Dart-level profile mode flag according flutter doc https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
// ignore: do_not_use_environment
const kDartProfileMode = bool.fromEnvironment("dart.vm.profile", defaultValue: false);
///Dart-level debug flag according flutter doc https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
bool get kDartDebugMode => !kDartReleaseMode && !kDartProfileMode;

/// A constant that is true if the application was compiled to run on the web.
// ignore: do_not_use_environment
const bool kDartIsWeb = bool.fromEnvironment("dart.library.js_util", defaultValue: false);

///VK ID base url
const kBaseUrl = "https://id.vk.com";