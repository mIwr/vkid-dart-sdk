
enum VkPrompt {
  ///No user interaction
  ///
  ///If user isn't authorized, will be thrown 'login_required' error
  ///If user didn't confirm access, will be thrown 'interaction_required' error
  none,
  ///Force user authorization process even with exist VK ID authorization
  login,
  ///Force user data consent even with granted permission
  consent
}

extension VkPromtExt on VkPrompt {

  static VkPrompt? from(String apiKey) {
    for (final item in VkPrompt.values) {
      if (item.name != apiKey) {
        continue;
      }
      return item;
    }
    return null;
  }

  String get apiKey {
    return name;
  }

}