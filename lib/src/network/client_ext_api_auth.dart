
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../network/client_mp.dart';

import '../extension/json_codec_ext.dart';
import '../model/vk_oauth.dart';
import '../network/model/vk_err.dart';
import '../network/model/vk_response_err.dart';
import '../network/model/vk_response_result.dart';
import '../model/vk_code_challenge_method.dart';
import '../global_constants.dart';
import '../network/model/vk_api_function.dart';
import '../util/vk_string_util.dart';
import '../util/vk_authorize_util.dart';

///Low level API client extension with authorization functions
extension ApiAuth on Client {

  ///Tries to generate the authorize uri
  static Uri? generateAuthorizeLink({required int clID, required String redirectUri, required String state, required String codeChallenge, String? codeVerifier, required VkCodeChallengeMethod codeChallengeMethod, List<String> scopes = const [], String? prompt, String? provider, int? langId, String? themeMode}) {
    if (state.length < VkAuthorizeUtil.kMinStateLength || !VkStringUtil.valid(state)) {
      print("Invalid VK state parameter. Parameter must have at least " + VkAuthorizeUtil.kMinStateLength.toString() + " characters and contains only a-z, A-Z, 0-9, '_', '-'");
      return null;
    }
    var cChallenge = codeChallenge;
    if (codeVerifier != null && codeVerifier.isNotEmpty) {
      if (codeVerifier.length < VkAuthorizeUtil.kMinCodeVerifierLength || codeVerifier.length > VkAuthorizeUtil.kMaxCodeVerifierLength || !VkStringUtil.valid(codeVerifier)) {
        print("Invalid VK code verifier parameter. Parameter must have" + VkAuthorizeUtil.kMinCodeVerifierLength.toString() + ".." + VkAuthorizeUtil.kMaxCodeVerifierLength.toString() + " bytes and contains only a-z, A-Z, 0-9, '_', '-'");
        return null;
      }
      cChallenge = codeVerifier;
      if (codeChallengeMethod == VkCodeChallengeMethod.sha256) {
        final codeVerifierDigest = sha256.convert(utf8.encode(codeVerifier));
        cChallenge = base64Url.encode(codeVerifierDigest.bytes).replaceAll("=", "");
      }
    }

    final Map<String, dynamic> queryParams = {
      "response_type": "code",
      "client_id": clID.toString(),
      //"app_id": clID.toString(),
      //"v": "2.1.0",
      //"sdk_type": "vkid",
      "redirect_uri": redirectUri,
      "code_challenge": cChallenge,
      "code_challenge_method": codeChallengeMethod.apiKey,
      "state": state,
    };
    if (scopes.isNotEmpty) {
      queryParams["scope"] = scopes.join(' ');
    }
    if (prompt != null && prompt.isNotEmpty) {
      queryParams["prompt"] = prompt;
    }
    if (provider != null && provider.isNotEmpty) {
      queryParams["provider"] = provider;
    }
    if (langId != null) {
      queryParams["lang_id"] = langId.toString();
    }
    if (themeMode != null) {
      queryParams["scheme"] = themeMode;
    }
    return Uri(scheme: "https", host: "id.vk.com", path: "authorize", queryParameters: queryParams);
  }

  ///Exchanges received from success login challenge for OAuth session
  Future<VkResponseResult<VkOAuth>> retrieveOAuthToken({required String code, required String deviceId, required String codeVerifier, required int clID, required String state, required String redirectUri, String? ip}) async {
    if (state.length < VkAuthorizeUtil.kMinStateLength || !VkStringUtil.valid(state)) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "state", description: "Invalid VK state parameter. Parameter must have at least " + VkAuthorizeUtil.kMinStateLength.toString() + " characters and contains only a-z, A-Z, 0-9, '_', '-'")));
    }
    if (codeVerifier.length < VkAuthorizeUtil.kMinCodeVerifierLength || codeVerifier.length > VkAuthorizeUtil.kMaxCodeVerifierLength || !VkStringUtil.valid(codeVerifier)) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "code_verifier", description: "Invalid VK code verifier parameter. Parameter must have" + VkAuthorizeUtil.kMinCodeVerifierLength.toString() + ".." + VkAuthorizeUtil.kMaxCodeVerifierLength.toString() + " bytes and contains only a-z, A-Z, 0-9, '_', '-'")));
    }
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      "grant_type": "authorization_code",
      "client_id": clID.toString(),
      "code_verifier": codeVerifier,
      "state": state,
      "code": code,
      "device_id": deviceId,
      "redirect_uri": redirectUri,
    };
    if (ip != null && ip.isNotEmpty) {
      bodyParams["ip"] = ip;
    }
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: "oauth2/auth", method: "POST", headers: headers, formData: bodyParams);
    final response = await sendAsync(apiFunc);
    final err = response.error;
    if (err != null) {
      return VkResponseResult(error: err);
    }
    final Map<String, dynamic> map = Map.from(response.result);
    final oauth = VkOAuth.from(map, createTsMsUTC: DateTime.now().toUtc().millisecondsSinceEpoch, deviceId: deviceId);
    return VkResponseResult(result: oauth, error: err);
  }

  ///Refreshes OAuth session
  Future<VkResponseResult<VkOAuth>> refreshOAuthToken({required String refreshToken, required String deviceId, required int clID, required String state, required String idToken, String? ip, List<String> scopes = const []}) async {
    if (state.length < VkAuthorizeUtil.kMinStateLength || !VkStringUtil.valid(state)) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "state", description: "Invalid VK state parameter. Parameter must have at least " + VkAuthorizeUtil.kMinStateLength.toString() + " characters and contains only a-z, A-Z, 0-9, '_', '-'")));
    }
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      "grant_type": "refresh_token",
      "client_id": clID.toString(),
      "refresh_token": refreshToken,
      "state": state,
      "device_id": deviceId,
    };
    if (ip != null && ip.isNotEmpty) {
      bodyParams["ip"] = ip;
    }
    if (scopes.isNotEmpty) {
      bodyParams["scope"] = scopes.join(' ');
    }
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: "oauth2/auth", method: "POST", headers: headers, formData: bodyParams);
    final response = await sendAsync(apiFunc);
    final err = response.error;
    if (err != null) {
      return VkResponseResult(error: err);
    }
    final Map<String, dynamic> map = Map.from(response.result);
    final oauth = VkOAuth.from(map, createTsMsUTC: DateTime.now().toUtc().millisecondsSinceEpoch, deviceId: deviceId, idToken: idToken);
    return VkResponseResult(result: oauth, error: err);
  }

  ///Revokes the granted permissions from OAuth session
  Future<VkResponseResult<bool>> revokeOAuthTokenPermissions({required int clID, required String accessToken}) async {
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      "access_token": accessToken,
      "client_id": clID.toString()
    };
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: "oauth2/revoke", method: "POST", headers: headers, formData: bodyParams);
    final response = await sendAsync(apiFunc);
    final err = response.error;
    if (err != null) {
      return VkResponseResult(error: err);
    }
    final Map<String, dynamic> map = Map.from(response.result);
    bool? success;
    if (map.containsKey("response")) {
      final key = json.tryGetIntFrom(map, key: "response");
      success = key == 1;
    }
    return VkResponseResult(result: success, error: err);
  }

  ///Invalidates OAUth session
  Future<VkResponseResult<bool>> logout({required int clID, required String accessToken}) async {
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };
    final Map<String, String> bodyParams = {
      "access_token": accessToken,
      "client_id": clID.toString()
    };
    final apiFunc = VkApiFunction(baseUrl: kBaseUrl, path: "oauth2/logout", method: "POST", headers: headers, formData: bodyParams);
    final response = await sendAsync(apiFunc);
    final err = response.error;
    if (err != null) {
      return VkResponseResult(error: err);
    }
    final Map<String, dynamic> map = Map.from(response.result);
    bool? success;
    if (map.containsKey("response")) {
      final key = json.tryGetIntFrom(map, key: "response");
      success = key == 1;
    }
    return VkResponseResult(result: success, error: err);
  }
}