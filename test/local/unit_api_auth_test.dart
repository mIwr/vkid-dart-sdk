import 'package:vk_id/src/model/vk_code_challenge_method.dart';
import 'package:vk_id/src/model/vk_scope.dart';
import 'package:vk_id/src/model/vk_theme_mode.dart';
import 'package:vk_id/src/network/api_auth.dart';
import 'package:test/test.dart';
import 'package:vk_id/src/util/vk_string_util.dart';

import '../test_constants.dart';

void main() {
  
  group('OAuth VK ID local API tests group', () {

    test("Authorize link generator test", () {
      final codeVerifier = VkStringUtil.generate(48);
      final state = VkStringUtil.generate(32);
      final uri = ApiAuth.generateAuthorizeLink(clID: TestConstants.kClientID, redirectUri: TestConstants.kRedirectUri, state: state, codeChallenge: "", codeVerifier: codeVerifier, codeChallengeMethod: VkCodeChallengeMethod.sha256, scopes: [VkScope.personalInfo.apiKey, VkScope.email.apiKey, VkScope.phone.apiKey], langId: 0, themeMode: VkThemeMode.dark.apiKey);
      expect(uri != null, true, reason: "Invalid authorize uri generator process");
    });

  });
}
