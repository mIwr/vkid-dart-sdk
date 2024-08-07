
///User genders
enum VkSex {
  ///Gender not stated
  notStated,
  ///Female gender
  female,
  ///Male gender
  male
}

extension VkSexExt on VkSex {

  static VkSex? from(int apiKey) {
    switch(apiKey) {
      case 0: return VkSex.notStated;
      case 1: return VkSex.female;
      case 2: return VkSex.male;
    }
    return null;
  }

  int get apiKey {
    switch (this) {
      case VkSex.notStated: return 0;
      case VkSex.female: return 1;
      case VkSex.male: return 2;
    }
  }

}