
import 'dart:async';

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:vk_id/src/controller/vk_id_controller.dart';
import 'package:vk_id/src/model/vk_oauth.dart';
import 'package:vk_id/src/model/vk_profile.dart';
import 'package:vk_id/src/model/vk_scope.dart';
import 'package:vk_id/src/util/vk_authorize_util.dart';
import 'package:vk_id/src/util/vk_string_util.dart';

import '../../test_constants.dart';

void main() {

  var controller = VkIDController(clID: TestConstants.kClientID);

  group("VK ID link generator tests group", () {

    test("Generate authorize link with random code verifier test", () {
      final entry = controller.generateAuthorizeLinkWithCodeVerifier(redirectUri: TestConstants.kRedirectUri);
      expect(entry.value != null, true, reason: "Invalid authorize link generator");
    });

    test("Generate authorize link with user-defined code verifier test", () {
      final codeVerifier = VkStringUtil.generate(VkAuthorizeUtil.kMinCodeVerifierLength);
      final entry = controller.generateAuthorizeLinkWithCodeVerifier(codeVerifier: codeVerifier, redirectUri: TestConstants.kRedirectUri);
      expect(entry.value != null, true, reason: "Invalid authorize link generator");
    });

    test("Generate authorize link with mixed scopes (predefined & custom) test", () {
      final scopes1 = [VkScope.personalInfo, VkScope.email];
      final scopes2 = [VkScope.email.apiKey, VkScope.phone.apiKey];
      final entry = controller.generateAuthorizeLinkWithCodeVerifier(redirectUri: TestConstants.kRedirectUri, scopes: scopes1, customScopeKeys: scopes2);
      expect(entry.value != null, true, reason: "Invalid authorize link generator");
      final scopeArgs = entry.value?.queryParameters["scope"]?.split(' ');
      expect(scopeArgs?.length, 3, reason: "Invalid scope mixer");
    });

  });
  
  group("VK ID controller update events tests group", () {

    StreamSubscription? oauthSubscription;
    StreamSubscription? profileSubscription;
    var oauthEventFired = false;
    var profileEventFired = false;

    void onOAuthEvent(VkOAuth? upd) {
      oauthEventFired = true;
    }

    void onProfileEvent(VkProfile? upd) {
      profileEventFired = true;
    }

    setUp(() {
      controller = VkIDController(clID: TestConstants.kClientID);
      oauthSubscription = controller.onOAuthUpdate.listen(onOAuthEvent);
      profileSubscription = controller.onProfileUpdate.listen(onProfileEvent);
    });

    tearDown(() {
      oauthSubscription?.cancel();
      profileSubscription?.cancel();
      oauthEventFired = false;
      profileEventFired = false;
    });

    test("OAuth update event test", () async {
      controller.reset();
      await Future.delayed(Duration(milliseconds: 200));
      expect(oauthEventFired, true, reason: "Event not fired");
    });

    test("Profile update event test", () async {
      controller.reset();
      await Future.delayed(Duration(milliseconds: 200));
      expect(profileEventFired, true, reason: "Event not fired");
    });

  });
}