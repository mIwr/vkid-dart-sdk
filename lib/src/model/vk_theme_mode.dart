
///Predefined OAuth form theme mode
enum VkThemeMode {
  ///Day/Light mode
  light,
  ///Night/Dark mode
  dark
}

///Predefined OAuth form theme mode extensions
extension VkThemeModeExt on VkThemeMode {

  ///Returns the string API key from predefined OAuth form theme mode
  String get apiKey {
    return name;
  }

}