import 'package:test/test.dart';
import 'package:vk_id/src/network/client_ext_api_profile.dart';

import '../test_constants.dart';

void main() {
  
  group('Profile VK ID local API tests group', () {

    test("Handle get masked profile info raw response test", () {
      final parsedRes = ApiProfile.handleGetProfileInfoResponse(TestConstants.kDummyMaskedProfileInfoResponse);
      final err = parsedRes.error;
      expect(err, null, reason: "Invalid masked profile info parser");
      final profile = parsedRes.result;
      expect(profile != null, true, reason: "Invalid masked profile info parser");
    });

    test("Handle get profile info raw response test", () {
      final parsedRes = ApiProfile.handleGetProfileInfoResponse(TestConstants.kDummyProfileInfoResponse);
      final err = parsedRes.error;
      expect(err, null, reason: "Invalid profile info parser");
      final profile = parsedRes.result;
      expect(profile != null, true, reason: "Invalid profile info parser");
    });
  });
}
