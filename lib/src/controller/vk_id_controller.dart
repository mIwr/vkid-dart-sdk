import 'dart:async';
import 'dart:collection';

import '../global_constants.dart';
import '../network/model/vk_response_result.dart';
import '../network/client_mp.dart';
import '../network/client_ext_api_auth.dart';
import '../network/client_ext_api_profile.dart';
import '../network/model/vk_err.dart';
import '../network/model/vk_err_type.dart';
import '../network/model/vk_response_err.dart';
import '../util/vk_authorize_util.dart';
import '../model/vk_code_challenge_method.dart';
import '../model/vk_theme_mode.dart';
import '../model/vk_lang_id.dart';
import '../model/vk_prompt.dart';
import '../model/vk_provider.dart';
import '../model/vk_scope.dart';
import '../model/vk_oauth.dart';
import '../model/vk_profile.dart';

///Represents VK ID OAuth controller
///
///Allows to authorize and retrieve user info
class VkIDController {

  ///White-listed redirect_uri variant for all platforms
  static const _kDefaultRedirectSuffix = "vk.com/blank.html";

  ///Multi-platform low-level API client
  static final _client = Client(baseUrl: kBaseUrl);

  ///VK client (app) ID
  final int clID;
  ///Authorization data
  VkOAuth? _oauth;
  ///Authorization data
  VkOAuth? get oauth {
    return _oauth;
  }
  ///Authorized user info
  VkProfile? _profile;
  ///Authorized user info
  VkProfile? get profile {
    return _profile;
  }

  ///OAuth login, refresh, logout events controller
  final StreamController<VkOAuth?> _oauthEventsController = StreamController.broadcast();
  ///OAuth login, refresh, logout events stream
  Stream<VkOAuth?> get onOAuthUpdate => _oauthEventsController.stream;

  ///User info events controller
  final StreamController<VkProfile?> _profileEventsController = StreamController.broadcast();
  ///User info events stream
  Stream<VkProfile?> get onProfileUpdate => _profileEventsController.stream;

  VkIDController({required this.clID, VkOAuth? oauth, VkProfile? profile}) {
    _oauth = oauth;
    if (oauth == null || profile == null) {
      if (profile != null) {
        print("Can't set profile info without active OAuth");
      }
      return;
    }
    if (oauth.userId != profile.userId) {
      print("Unable to set profile: OAuth UID '" + oauth.userId.toString() + "' not equals Profile UID '" + profile.userId.toString() + '\'');
      return;
    }
    _profile = profile;
  }

  ///Generate authorize link in front-end mode with code verifier
  ///
  ///If code verifier not stated, it will be generated automatically
  ///If redirectUri not stated (Android and iOS cases), it will be generated automatically as uri 'vk{clientID}://vk.com/blank.html'
  ///Returns Map entry, where key is code verifier (provided or generated) and value is generated authorize link (optional)
  MapEntry<String, Uri?> generateAuthorizeLinkWithCodeVerifier({String? codeVerifier, String? redirectUri, List<VkScope> scopes = const [], List<String> customScopeKeys = const[], VkPrompt? prompt, String? customPromptKey, VkProvider? provider, String? customProviderKey, VkLangId? langId, int? customLangId, VkThemeMode? theme, String? customTheme}) {
    final safeCodeVerifier = codeVerifier ?? VkAuthorizeUtil.generateCodeVerifierWithCodeChallenge().key;
    return MapEntry(safeCodeVerifier, _generateAuthorizeLink(codeChallenge: "", codeVerifier: safeCodeVerifier, redirectUri: redirectUri, scopes: scopes, customScopeKeys: customScopeKeys, prompt: prompt, customPromptKey: customPromptKey, provider: provider, customProviderKey: customProviderKey, langId: langId, customLangId: customLangId, theme: theme, customTheme: customTheme));
  }

  ///Generate authorize link with back-end mode with code challenge
  ///
  ///If redirectUri not stated (Android and iOS cases), it will be generated automatically as uri 'vk{clientID}://vk.com/blank.html'
  Uri? generateAuthorizeLinkWithCodeChallenge({required String codeChallenge, String? redirectUri, List<VkScope> scopes = const [], List<String> customScopeKeys = const[], VkPrompt? prompt, String? customPromptKey, VkProvider? provider, String? customProviderKey, VkLangId? langId, int? customLangId, VkThemeMode? theme, String? customTheme}) {
    return _generateAuthorizeLink(codeChallenge: codeChallenge, codeVerifier: null, redirectUri: redirectUri, scopes: scopes, customScopeKeys: customScopeKeys, prompt: prompt, customPromptKey: customPromptKey, provider: provider, customProviderKey: customProviderKey, langId: langId, customLangId: customLangId, theme: theme, customTheme: customTheme);
  }

  ///Universal authorize link generator
  Uri? _generateAuthorizeLink({required String codeChallenge, required String? codeVerifier, String? redirectUri, required List<VkScope> scopes, required List<String> customScopeKeys, required VkPrompt? prompt, required String? customPromptKey, required VkProvider? provider, required String? customProviderKey, required VkLangId? langId, required int? customLangId, required VkThemeMode? theme, required String? customTheme}) {
    final scopesSet = HashSet<String>.from(scopes.map((e) => e.apiKey));
    for (final scopeKey in customScopeKeys) {
      if ( scopeKey.isEmpty || scopesSet.contains(scopeKey)) {
        continue;
      }
      scopesSet.add(scopeKey);
    }
    var promptKey = prompt?.apiKey;
    if (customPromptKey != null && customPromptKey.isNotEmpty) {
      promptKey = customPromptKey;
    }
    var providerKey = provider?.apiKey;
    if (customProviderKey != null && customProviderKey.isNotEmpty) {
      providerKey = customProviderKey;
    }
    var langIdKey = langId?.apiKey;
    if (customLangId != null) {
      langIdKey = customLangId;
    }
    var themeKey = theme?.apiKey;
    if (customTheme != null && customTheme.isNotEmpty) {
      themeKey = customTheme;
    }
    final state = VkAuthorizeUtil.generateState();
    var safeRedirectUri = "vk" + clID.toString() + "://" + VkIDController._kDefaultRedirectSuffix;
    if (redirectUri != null && redirectUri.isNotEmpty) {
      print("Warning: overridden redirect_uri may use only for VK web apps. For Android and iOS set redirectUri as null");
      safeRedirectUri = redirectUri;
    }
    return ApiAuth.generateAuthorizeLink(clID: clID, redirectUri: safeRedirectUri, state: state, codeChallenge: codeChallenge, codeVerifier: codeVerifier, codeChallengeMethod: VkCodeChallengeMethod.sha256, scopes: scopesSet.toList(growable: false), prompt: promptKey, provider: providerKey, langId: langIdKey, themeMode: themeKey);
  }

  ///Exchange authorization code for access token
  Future<VkResponseResult<VkOAuth>> retrieveOAuthToken({required String authorizationCode, required String deviceId, required String codeVerifier, required String state, String? redirectUri, String? ip}) async {
    var safeRedirectUri = "vk" + clID.toString() + "://" + VkIDController._kDefaultRedirectSuffix;
    if (redirectUri != null && redirectUri.isNotEmpty) {
      safeRedirectUri = redirectUri;
    }
    final oauthRes = await VkIDController._client.retrieveOAuthToken(code: authorizationCode, deviceId: deviceId, codeVerifier: codeVerifier, clID: clID, state: state, redirectUri: safeRedirectUri, ip: ip);
    final auth = oauthRes.result;
    if (auth == null) {
      return oauthRes;
    }
    _oauth = auth;
    _oauthEventsController.add(auth);
    final prf = _profile;
    if (prf != null && prf.userId != auth.userId) {
      _profile = null;
      _profileEventsController.add(null);
    }
    return oauthRes;
  }

  ///Refresh access token by refresh token from OAuth
  Future<VkResponseResult<VkOAuth>> refreshOAuthToken({String? ip, List<VkScope> scopes = const [], List<String> customScopeKeys = const[]}) async {
    final auth = _oauth;
    if (auth == null || auth.refreshToken.isEmpty) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: VkErrType.invalidRequest.apiKey, description: "Unable to refresh the access token - no authorization or empty refresh token")));
    }
    final scopesSet = HashSet<String>.from(scopes.map((e) => e.apiKey));
    for (final scopeKey in customScopeKeys) {
      if ( scopeKey.isEmpty || scopesSet.contains(scopeKey)) {
        continue;
      }
      scopesSet.add(scopeKey);
    }
    final refreshRes = await VkIDController._client.refreshOAuthToken(refreshToken: auth.refreshToken, deviceId: auth.deviceId, clID: clID, state: auth.state, idToken: auth.idToken, ip: ip, scopes: scopesSet.toList(growable: false));
    final refreshedAuth = refreshRes.result;
    if (refreshedAuth == null) {
      final err = refreshRes.error;
      if (err != null) {
        _processVkResponseErr(err);
      }
      return refreshRes;
    }
    _oauth = refreshedAuth;
    _oauthEventsController.add(refreshedAuth);
    final prf = _profile;
    if (prf != null && prf.userId != refreshedAuth.userId) {
      _profile = null;
      _profileEventsController.add(null);
    }
    return refreshRes;
  }

  ///Revoke permission for profile info from oauth
  Future<VkResponseResult<bool>> revoke() async {
    final safeAuthRes = await _retrieveActiveOAuth();
    final auth = safeAuthRes.result;
    if (auth == null || auth.accessToken.isEmpty || auth.expired) {
      return VkResponseResult(error: safeAuthRes.error);
    }
    final revokeRes = await VkIDController._client.revokeOAuthTokenPermissions(clID: clID, accessToken: auth.accessToken);
    final status = revokeRes.result;
    if (status != true) {
      final err = revokeRes.error;
      if (err != null) {
        _processVkResponseErr(err);
      }
    }
    return revokeRes;
  }

  ///Invalidate authorization token
  Future<VkResponseResult<bool>> logout() async {
    final safeAuthRes = await _retrieveActiveOAuth();
    final auth = safeAuthRes.result;
    if (auth == null || auth.accessToken.isEmpty || auth.expired) {
      return VkResponseResult(error: safeAuthRes.error);
    }
    final logoutRes = await VkIDController._client.logout(clID: clID, accessToken: auth.accessToken);
    final status = logoutRes.result;
    if (status != true) {
      final err = logoutRes.error;
      if (err != null) {
        _processVkResponseErr(err);
      }
      return logoutRes;
    }
    _oauth = null;
    _oauthEventsController.add(null);
    _profile = null;
    _profileEventsController.add(null);
    return logoutRes;
  }

  ///Get public (masked) profile info
  Future<VkResponseResult<VkProfile>> getMaskedProfileInfo() async {
    var auth = _oauth;
    if (auth == null) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: VkErrType.invalidRequest.apiKey, description: "Unable to get masked profile info - no authorization")));
    }
    if (auth.idToken.isEmpty) {
      if (auth.refreshToken.isEmpty) {
        return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: VkErrType.invalidRequest.apiKey, description: "Unable to refresh the ID token - empty refresh token")));
      }
      final refreshRes = await refreshOAuthToken();
      auth = refreshRes.result;
      if (auth == null || auth.idToken.isEmpty) {
        return VkResponseResult(error: refreshRes.error);
      }
    }
    final profileRes = await VkIDController._client.getMaskedProfileInfo(idToken: auth.idToken, clID: clID);
    final prf = profileRes.result;
    if (prf == null) {
      final err = profileRes.error;
      if (err != null) {
        _processVkResponseErr(err);
      }
      return profileRes;
    }
    _profile = prf;
    _profileEventsController.add(prf);
    return profileRes;
  }

  ///Get full profile info
  Future<VkResponseResult<VkProfile>> getProfileInfo() async {
    final safeAuthRes = await _retrieveActiveOAuth();
    final auth = safeAuthRes.result;
    if (auth == null || auth.accessToken.isEmpty || auth.expired) {
      return VkResponseResult(error: safeAuthRes.error);
    }
    final profileRes = await VkIDController._client.getProfileInfo(accessToken: auth.accessToken, clID: clID);
    final prf = profileRes.result;
    if (prf == null) {
      final err = profileRes.error;
      if (err != null) {
        _processVkResponseErr(err);
      }
      return profileRes;
    }
    _profile = prf;
    _profileEventsController.add(prf);
    return profileRes;
  }

  ///Reset controller data
  void reset() {
    _profile = null;
    _profileEventsController.add(null);
    _oauth = null;
    _oauthEventsController.add(null);
  }

  ///Gets if exists or refreshes if needed OAuth session
  Future<VkResponseResult<VkOAuth>> _retrieveActiveOAuth() async {
    var auth = _oauth;
    if (auth == null) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: VkErrType.invalidRequest.apiKey, description: "Unable to get masked profile info - no authorization")));
    }
    if (auth.accessToken.isNotEmpty && !auth.expired) {
      return VkResponseResult(result: auth);
    }
    if (auth.refreshToken.isEmpty) {
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: VkErrType.invalidRequest.apiKey, description: "Unable to refresh the ID token - empty refresh token")));
    }
    return await refreshOAuthToken();
  }

  ///Controller-level error handler
  ///
  ///Drops authorization and user info for certain api errors
  void _processVkResponseErr(VkResponseErr err) {
    final errKey = err.vkErr?.error;
    if (errKey == null || errKey.isEmpty || (errKey != VkErrTypeExt.kAccessDeniedKey || errKey != VkErrTypeExt.kInvalidTokenKey || errKey != VkErrTypeExt.kInvalidClientKey)) {
      //Non-critical errors -> no-op
      return;
    }
    //Error leads to auth drop
    reset();
  }
}