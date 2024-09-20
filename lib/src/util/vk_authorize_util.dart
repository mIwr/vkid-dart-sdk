
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'vk_string_util.dart';
import '../model/vk_code_challenge_method.dart';

///VK ID authorize link generator utils
abstract class VkAuthorizeUtil {

  ///State parameter minimum length
  static const kMinStateLength = 32;
  ///Code verifier parameter minimum length
  static const kMinCodeVerifierLength = 43;
  ///Code verifier parameter maximum length
  static const kMaxCodeVerifierLength = 128;

  ///Generates random code verifier and its code challenge
  static MapEntry<String, String> generateCodeVerifierWithCodeChallenge() {
    var rnd = Random();
    var length = rnd.nextInt(kMaxCodeVerifierLength);
    if (length < kMinCodeVerifierLength) {
      length = kMinCodeVerifierLength;
    }
    final codeVerifier = VkStringUtil.generate(length);
    final codeChallenge = retrieveCodeChallenge(codeVerifier: codeVerifier, challengeMethod: VkCodeChallengeMethod.sha256);
    return MapEntry(codeVerifier, codeChallenge);
  }

  ///Retrieves code challenge from code verifier
  static String retrieveCodeChallenge({required String codeVerifier, required VkCodeChallengeMethod challengeMethod}) {
    switch (challengeMethod) {
      case VkCodeChallengeMethod.plain: return codeVerifier;
      case VkCodeChallengeMethod.sha256:
        final codeVerifierDigest = sha256.convert(utf8.encode(codeVerifier));
        return base64Url.encode(codeVerifierDigest.bytes).replaceAll("=", "");
    }
  }

  ///Generates random state
  static String generateState() {
    return VkStringUtil.generate(kMinStateLength);
  }

}