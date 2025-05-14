import '../model/vk_profile.dart';
import '../network/client.dart';
import '../model/network/vk_response_result.dart';
import '../global_constants.dart';
import '../model/network/vk_api_function.dart';

///Low level API client extension with profile functions
extension ApiProfile on Client {

  ///Gets the brief (masked) profile info
  Future<VkResponseResult<VkProfile>> getMaskedProfileInfo({required String idToken, required int clID}) {
    return _getProfileInfo(tokenKey: "id_token", tokenVal: idToken, clID: clID, path: "oauth2/public_info");
  }

  ///Gets the full profile info (according granted scopes)
  Future<VkResponseResult<VkProfile>> getProfileInfo({required String accessToken, required int clID}) {
    return _getProfileInfo(tokenKey: "access_token", tokenVal: accessToken, clID: clID, path: "oauth2/user_info");
  }

  ///Universal method for retrieving profile info
  Future<VkResponseResult<VkProfile>> _getProfileInfo({required String tokenKey, required String tokenVal, required int clID, required String path}) async {
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      tokenKey: tokenVal,
      "client_id": clID.toString()
    };
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: path, method: "POST", headers: headers, formData: bodyParams);
    final response = await sendAsync(apiFunc);
    return ApiProfile.handleGetProfileInfoResponse(response);
  }

  ///Parses raw 'get profile info' response
  static VkResponseResult<VkProfile> handleGetProfileInfoResponse(VkResponseResult<dynamic> response) {
    final err = response.error;
    if (err != null) {
      return VkResponseResult(error: err);
    }
    final Map<String, dynamic> map = Map.from(response.result);
    VkProfile? profile;
    if (map.containsKey("user") && map["user"] is Map) {
      final Map<String, dynamic> userMap = Map.from(map["user"]);
      profile = VkProfile.from(userMap);
    }
    return VkResponseResult(result: profile, error: err);
  }
}