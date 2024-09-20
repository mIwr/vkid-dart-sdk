
///Predefined VK ID authorization flow type
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

///Predefined VK ID authorization flow type extensions
extension VkPromtExt on VkPrompt {

  ///Tries to parse predefined VK ID authorization flow type from string API key
  static VkPrompt? from(String apiKey) {
    for (final item in VkPrompt.values) {
      if (item.name != apiKey) {
        continue;
      }
      return item;
    }
    return null;
  }

  ///Returns the string API key according predefined VK ID authorization flow type
  String get apiKey {
    return name;
  }

}