
///OAuth provider
enum VkProvider {

  ///VK ID. Default value
  vkID,
  ///ok.ru
  okRu,
  ///mail.ru
  mailRu
}

///OAuth provider extensions
extension VkProviderExt on VkProvider {

  ///VK ID OAuth provider
  static const kVkIDKey = "vkid";
  ///OK OAuth provider
  static const kOkRuKey = "ok_ru";
  ///Mail OAuth provider
  static const kMailRuKey = "mail_ru";

  ///Tries to parse predefined OAuth provider from string API key
  static VkProvider? from(String apiKey) {
    switch (apiKey) {
      case kVkIDKey: return VkProvider.vkID;
      case kOkRuKey: return VkProvider.okRu;
      case kMailRuKey: return VkProvider.mailRu;
    }
    return null;
  }

  ///Returns the string API key from predefined OAuth provider
  String get apiKey {
    switch(this) {
      case VkProvider.vkID: return kVkIDKey;
      case VkProvider.okRu: return kOkRuKey;
      case VkProvider.mailRu: return kMailRuKey;
    }
  }

}