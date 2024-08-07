
///OAuth form theme mode
enum VkThemeMode {
  ///Day/Light mode
  light,
  ///Night/Dark mode
  dark
}

extension VkThemeModeExt on VkThemeMode {

  String get apiKey {
    return name;
  }

}