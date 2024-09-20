
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

///Predefined VK error ('error' field) type keys extensions
extension VkErrTypeExt on VkErrType {

  ///Access denied error key
  static const kAccessDeniedKey = "access_denied";
  ///Invalid token error key
  static const kInvalidTokenKey = "invalid_token";
  ///Server error key
  static const kServerErrorKey = "server_error";
  ///Too many requests error key
  static const kSlowDownKey = "slow_down";
  ///Service is temporary unavailable error key
  static const kTemporarilyUnavailableKey = "temporarily_unavailable";
  ///Invalid VK ID client error key
  static const kInvalidClientKey = "invalid_client";
  ///Invalid ID token error key
  static const kInvalidIdTokenKey = "invalid_id_token";
  ///Invalid VK ID API request error key
  static const kInvalidRequestKey = "invalid_request";

  ///Tries to parse predefined VK ID error type from string API key
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

  ///Returns string API key according predefined VK ID error type
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

