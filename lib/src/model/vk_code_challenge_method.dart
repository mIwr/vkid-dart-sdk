
///Predefined VK ID code challenge retrieve method
enum VkCodeChallengeMethod {
  ///code_challenge = code_verifier
  plain,
  ///code_challenge = BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))
  sha256
}

///Predefined VK ID code challenge retrieve method extensions
extension VkCodeChallengeMethodExt on VkCodeChallengeMethod {

  ///Code challenge is equal to code verifier key
  static const kPlainKey = "plain";
  ///Code challenge is a result from BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))
  static const kSha256Key = "s256";

  ///Tries to parse predefined VK ID code challenge retrieve method from string API key
  static VkCodeChallengeMethod? from(String apiKey) {
    switch(apiKey) {
      case kPlainKey: return VkCodeChallengeMethod.plain;
      case kSha256Key: return VkCodeChallengeMethod.sha256;
    }
    return null;
  }

  ///Returns string API key according the predefined VK ID code challenge retrieve method
  String get apiKey {
    switch (this) {
      case VkCodeChallengeMethod.plain: return kPlainKey;
      case VkCodeChallengeMethod.sha256: return kSha256Key;
    }
  }
}