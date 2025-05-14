import 'package:vk_id/src/network/client_ext_api_auth.dart';
import 'package:test/test.dart';
import 'package:vk_id/vk_id.dart';

import '../test_constants.dart';

void main() {
  
  group('OAuth VK ID local API tests group', () {

    test("Authorize link generator test", () {
      final codeVerifier = VkStringUtil.generate(48);
      final state = VkStringUtil.generate(32);
      final uri = ApiAuth.generateAuthorizeLink(clID: TestConstants.kClientID, redirectUri: TestConstants.kRedirectUri, state: state, codeChallenge: "", codeVerifier: codeVerifier, codeChallengeMethod: VkCodeChallengeMethod.sha256, scopes: [VkScope.personalInfo.apiKey, VkScope.email.apiKey, VkScope.phone.apiKey], langId: 0, themeMode: VkThemeMode.dark.apiKey);
      expect(uri != null, true, reason: "Invalid authorize uri generator process");
    });

    test("Handle retrieve OAuth token raw response test", () {
      final parsedRes = ApiAuth.handleRetrieveOAuthTkResponse(TestConstants.kDummyOAuthTokenResponse, deviceId: "deviceID");
      final err = parsedRes.error;
      expect(err, null, reason: "Invalid OAuth token parser");
      final oauth = parsedRes.result;
      expect(oauth != null, true, reason: "Invalid OAuth token parser");
    });

    test("Handle refresh OAuth token raw response test", () {
      final parsedRes = ApiAuth.handleRefreshOAuthTkResponse(TestConstants.kDummyRefreshOAuthTokenResponse, idToken: "idToken", deviceId: "deviceID");
      final err = parsedRes.error;
      expect(err, null, reason: "Invalid OAuth token parser");
      final oauth = parsedRes.result;
      expect(oauth != null, true, reason: "Invalid OAuth token parser");
    });
  });
}
