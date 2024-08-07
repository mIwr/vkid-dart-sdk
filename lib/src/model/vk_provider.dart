
///Auth provider
enum VkProvider {

  ///VK ID. Default value
  vkID,
  ///ok.ru
  okRu,
  ///mail.ru
  mailRu
}

extension VkProviderExt on VkProvider {

  static const kVkIDKey = "vkid";
  static const kOkRuKey = "ok_ru";
  static const kMailRuKey = "mail_ru";

  static VkProvider? from(String apiKey) {
    switch (apiKey) {
      case kVkIDKey: return VkProvider.vkID;
      case kOkRuKey: return VkProvider.okRu;
      case kMailRuKey: return VkProvider.mailRu;
    }
    return null;
  }

  String get apiKey {
    switch(this) {
      case VkProvider.vkID: return kVkIDKey;
      case VkProvider.okRu: return kOkRuKey;
      case VkProvider.mailRu: return kMailRuKey;
    }
  }

}