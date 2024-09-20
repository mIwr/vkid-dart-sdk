
import 'dart:convert';

import 'vk_scope.dart';
import '../extension/json_codec_ext.dart';

///VK ID OAuth data
class VkOAuth {

  ///VK user ID
  final int userId;
  ///VK ID access token
  final String accessToken;
  ///VK ID refresh token
  final String refreshToken;
  ///VK ID token
  final String idToken;
  ///Token type
  final String tokenType;
  ///Authorization timestamp (UTC+0)
  final int createTsMsUTC;
  ///Authorization local date time
  DateTime get createDtLocal {
    return DateTime.fromMillisecondsSinceEpoch(createTsMsUTC, isUtc: true).toLocal();
  }
  ///Access token life duration in secs
  final int expiresInS;
  ///Access token expired flag
  bool get expired {
    final expiresTsMsUTC = createTsMsUTC + (expiresInS * 1000);
    final nowTsMsUTC = DateTime.now().toUtc().millisecondsSinceEpoch;
    return expiresTsMsUTC <= nowTsMsUTC;
  }
  ///Access token expiration local date time
  DateTime get expiresDtLocal {
    final expiresTsMsUTC = createTsMsUTC + (expiresInS * 1000);
    return DateTime.fromMillisecondsSinceEpoch(expiresTsMsUTC, isUtc: true).toLocal();
  }
  ///OAuth state
  final String state;
  ///OAuth device ID
  final String deviceId;
  ///OAuth permission scopes
  final List<String> scopes;
  ///Parsed OAuth permission scope types
  List<VkScope> get parsedScopes {
    final List<VkScope> res = [];
    for (final scope in scopes) {
      final parsed = VkScopeExt.from(scope);
      if (parsed == null) {
        continue;
      }
      res.add(parsed);
    }
    return res;
  }

  const VkOAuth({required this.userId, required this.accessToken, required this.refreshToken, required this.idToken, required this.tokenType, required this.createTsMsUTC, required this.expiresInS, required this.state, required this.deviceId, required this.scopes});

  ///Tries to parse an instance from json map
  static VkOAuth? from(Map<String, dynamic> jsonMap, {required int createTsMsUTC, required String deviceId, String? idToken}) {
    if (!jsonMap.containsKey("user_id") || !jsonMap.containsKey("access_token") || !jsonMap.containsKey("refresh_token") || !jsonMap.containsKey("token_type") || !jsonMap.containsKey("expires_in")) {
      return null;
    }
    final uid = json.tryGetIntFrom(jsonMap, key: "user_id");
    if (uid == null) {
      return null;
    }
    final String accessTk = jsonMap["access_token"];
    final String refreshTk = jsonMap["refresh_token"];
    final String idTk = jsonMap["id_token"] ?? idToken ?? "";
    final String tkType = jsonMap["token_type"];
    final expiresInS = json.tryGetIntFrom(jsonMap, key: "expires_in");
    if (expiresInS == null || expiresInS <= 0) {
      return null;
    }
    final String state = jsonMap["state"] ?? "";
    final String scopeLine = jsonMap["scope"] ?? "";
    final scopes = scopeLine.split(' ');

    return VkOAuth(userId: uid, accessToken: accessTk, refreshToken: refreshTk, idToken: idTk, tokenType: tkType, createTsMsUTC: createTsMsUTC, expiresInS: expiresInS, state: state, deviceId: deviceId, scopes: scopes);
  }

}