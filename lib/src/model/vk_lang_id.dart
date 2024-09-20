
///Predefined VK ID OAuth API language
enum VkLangId {
  ///Russian
  rus,
  ///Ukrainian
  ukr,
  ///English
  eng,
  ///Spanish
  spa,
  ///German
  german,
  ///Polish
  pol,
  ///French
  fra,
  ///Turkish
  turkey
}

///Predefined VK ID OAuth API language extensions
extension VkLangIdExt on VkLangId {

  ///Tries to parse predefined VK ID OAuth API language from int API key
  static VkLangId? from(int apiKey) {
    switch(apiKey) {
      case 0: return VkLangId.rus;
      case 1: return VkLangId.ukr;
      case 3: return VkLangId.eng;
      case 4: return VkLangId.spa;
      case 6: return VkLangId.german;
      case 15: return VkLangId.pol;
      case 16: return VkLangId.fra;
      case 82: return VkLangId.turkey;
    }
    return null;
  }

  ///Returns int API key according the predefined VK ID OAuth API language
  int get apiKey {
    switch(this) {
      case VkLangId.rus: return 0;
      case VkLangId.ukr: return 1;
      case VkLangId.eng: return 3;
      case VkLangId.spa: return 4;
      case VkLangId.german: return 6;
      case VkLangId.pol: return 15;
      case VkLangId.fra: return 16;
      case VkLangId.turkey: return 82;
    }
  }

}