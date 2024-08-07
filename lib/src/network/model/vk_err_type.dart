

///Predefined VK error ('error' field) type keys
enum VkErrType {
  ///No VK ID access - user is banned or deleted
  accessDenied,
  ///Not stated or invalid access token
  invalidToken,
  ///HTTP 500 Internal Server Error analogue during HTTP redirect
  serverError,
  ///Request limit exceeded. Slow down
  slowDown,
  ///Auth server overload. HTTP 503 Service Unavailable analogue during HTTP redirect
  temporarilyUnavailable,
  ///Client ID not found or blocked
  invalidClient,
  ///Not stated or invalid ID token
  invalidIdToken,
  ///Not found or invalid the required parameter(-s) on request
  invalidRequest,
}

extension VkErrTypeExt on VkErrType {

  static const kAccessDeniedKey = "access_denied";
  static const kInvalidTokenKey = "invalid_token";
  static const kServerErrorKey = "server_error";
  static const kSlowDownKey = "slow_down";
  static const kTemporarilyUnavailableKey = "temporarily_unavailable";
  static const kInvalidClientKey = "invalid_client";
  static const kInvalidIdTokenKey = "invalid_id_token";
  static const kInvalidRequestKey = "invalid_request";

  static VkErrType? from(String apiKey) {
    switch(apiKey) {
      case kAccessDeniedKey: return VkErrType.accessDenied;
      case kInvalidTokenKey: return VkErrType.invalidToken;
      case kServerErrorKey: return VkErrType.serverError;
      case kSlowDownKey: return VkErrType.slowDown;
      case kTemporarilyUnavailableKey: return VkErrType.temporarilyUnavailable;
      case kInvalidClientKey: return VkErrType.invalidClient;
      case kInvalidIdTokenKey: return VkErrType.invalidIdToken;
      case kInvalidRequestKey: return VkErrType.invalidRequest;
    }
    return null;
  }

  String get apiKey {
    switch(this) {
      case VkErrType.accessDenied: return kAccessDeniedKey;
      case VkErrType.invalidToken: return kInvalidTokenKey;
      case VkErrType.serverError: return kServerErrorKey;
      case VkErrType.slowDown: return kSlowDownKey;
      case VkErrType.temporarilyUnavailable: return kTemporarilyUnavailableKey;
      case VkErrType.invalidClient: return kInvalidClientKey;
      case VkErrType.invalidIdToken: return kInvalidIdTokenKey;
      case VkErrType.invalidRequest: return kInvalidRequestKey;
    }
  }
}

