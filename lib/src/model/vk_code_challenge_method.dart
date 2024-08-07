
enum VkCodeChallengeMethod {
  ///code_challenge = code_verifier
  plain,
  ///code_challenge = BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))
  sha256
}

extension VkCodeChallengeMethodExt on VkCodeChallengeMethod {

  static const kPlainKey = "plain";
  static const kSha256Key = "s256";

  static VkCodeChallengeMethod? from(String apiKey) {
    switch(apiKey) {
      case kPlainKey: return VkCodeChallengeMethod.plain;
      case kSha256Key: return VkCodeChallengeMethod.sha256;
    }
    return null;
  }

  String get apiKey {
    switch (this) {
      case VkCodeChallengeMethod.plain: return kPlainKey;
      case VkCodeChallengeMethod.sha256: return kSha256Key;
    }
  }
}