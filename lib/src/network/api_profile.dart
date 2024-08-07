import '../model/vk_profile.dart';
import '../network/client_mp.dart';
import '../network/model/vk_response_result.dart';
import '../global_constants.dart';
import '../network/model/vk_api_function.dart';

abstract class ApiProfile {

  static Future<VkResponseResult<VkProfile>> getMaskedProfileInfo({required Client client, required String idToken, required int clID}) {
    return _getProfileInfo(client: client, tokenKey: "id_token", tokenVal: idToken, clID: clID, path: "oauth2/public_info");
  }

  static Future<VkResponseResult<VkProfile>> getProfileInfo({required Client client, required String accessToken, required int clID}) {
    return _getProfileInfo(client: client, tokenKey: "access_token", tokenVal: accessToken, clID: clID, path: "oauth2/user_info");
  }

  static Future<VkResponseResult<VkProfile>> _getProfileInfo({required Client client, required String tokenKey, required String tokenVal, required int clID, required String path}) async {
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      tokenKey: tokenVal,
      "client_id": clID.toString()
    };
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: path, method: "POST", headers: headers, formData: bodyParams);
    final response = await client.sendAsync(apiFunc);
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