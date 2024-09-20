
///Predefined VK ID permission scope
enum VkScope {
  ///Account personal info (vkid.personal_info). Default scope
  personalInfo,
  ///Account email
  email,
  ///Account phone number
  phone,
  ///User friends
  friends,
  ///User wall content
  wall,
  ///User groups
  groups,
  ///User stories
  stories,
  ///User docs
  docs,
  ///User photos
  photos,
  ///User ads API
  ads,
  ///User videos
  videos,
  ///Shop market items
  market,
  ///Wiki pages
  pages,
  ///Account notifications
  notifications,
  ///Administrator info for owned groups and apps
  stats,
  ///Account notes
  notes,
}

///Predefined VK ID permission scope extensions
extension VkScopeExt on VkScope {

  ///Account personal info scope API key
  static const kPersonalInfoApiKey = "vkid.personal_info";

  ///Tries to parse predefined VK ID permission scope from string API key
  static VkScope? from(String apiKey) {
    if (apiKey == VkScopeExt.kPersonalInfoApiKey) {
      return VkScope.personalInfo;
    }
    for (final scope in VkScope.values) {
      if (scope.name != apiKey) {
        continue;
      }
      return scope;
    }
    return null;
  }

  ///Returns the string API key from predefined VK ID permission scope
  String get apiKey {
    if (this == VkScope.personalInfo) {
      return kPersonalInfoApiKey;
    }
    return name;
  }

}