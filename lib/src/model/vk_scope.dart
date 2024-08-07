
///VK ID permission scopes
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

extension VkScopeExt on VkScope {

  static const kPersonalInfoApiKey = "vkid.personal_info";

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

  String get apiKey {
    if (this == VkScope.personalInfo) {
      return kPersonalInfoApiKey;
    }
    return name;
  }

}