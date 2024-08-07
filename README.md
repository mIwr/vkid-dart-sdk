# VK ID

[![pub package](https://img.shields.io/pub/v/vk_id.svg)](https://pub.dev/packages/vk_id)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](./LICENSE)

Pure dart impl of [OAuth VK ID API](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/api-integration/api-description).
The module allows to generate 'authorize' link, retrieve OAuth token and user data

## General

- Dart SDK >=3.3.0

Supports 2 modes:

- [Front-end authorization code exchange without SDK](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/web/auth-flow-web#Bez-SDK-s-obmenom-koda-na-frontende): Generating random code_verifier and state at front-end
- [Back-end authorization code exchange without SDK](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/web/auth-flow-web#Bez-SDK-s-obmenom-koda-na-bekende): Generating random code_verifier and state at back-end and sending code_challenge with state to front-end

Supports VK app platforms:

- Android
- iOS
- Web

**Notice: You aren't strictly bound between the hardware and the VK app platform. For example, you can authorize on iOS VK app using Android device**

Supports VK ID APIs:

- Generating 'auhtorize' link for VK ID with code_verifier or code_challenge
- Exchange received from passed user login redirect authorization code for access, refresh, id tokens
- Refresh access token through refresh token
- Get public (masked) user info
- Get full (unmasked) user info
- Revoke permissions for authorization
- Invalidate authorization (Logout)

**Notice**: This module doesn't support user authorization. Use webview on flutter context to do it

## Setup

1. [Create and setup VK app](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/create-application)
2. Create [VkIDController](./lib/src/controller/vk_id_controller.dart) instance with VK app client ID

**If you have previously saved authorization, you can set init oauth and profile data for controller ctor**

## Authorization

### Generating authorize link

You may generate authorize link itself (redirect_uri and code_challenge or code_verifier) or request the generated link from back-end

- Android, iOS: Redirect uri must be 'vk{clientID}://vk.com/blank.html'. Otherwise VK will throw an error for authorize
- Web: Redirect uri must match with uri from VK web app settings. Also you can use default value from Android and iOS apps (vk{clientID}://vk.com/blank.html)

**Authorize link generation examples**

1. Android and iOS with code_challenge
```dart
final controller = VkIDController(clID: 1234567890);
//Generate code_verifier and code_challenge itself or get code_challenge from back-end
final codeChallenge = "1234567890RND0987654321";
final uri = controller.generateAuthorizeLinkWithCodeChallenge(codeChallenge: codeChallenge);
```

2. Android and iOS with random code_verifier
```dart
final controller = VkIDController(clID: 1234567890);
final codeVerifierWithUri = controller.generateAuthorizeLinkWithCodeVerifier();
```

3. Android and iOS with user-defined code_verifier
```dart
final controller = VkIDController(clID: 1234567890);
//Generate code_verifier
final codeVerifier = "1234567890RND0987654321";
final codeVerifierWithUri = controller.generateAuthorizeLinkWithCodeVerifier(codeVerifier: codeVerifier);
```

4. Web with code_challenge and user-defined redirect_uri from VK web app settings
```dart
final controller = VkIDController(clID: 1234567890);
final redirectUri = "https://site.com/redirect";
//Generate code_verifier and code_challenge itself or get code_challenge from back-end
final codeChallenge = "1234567890RND0987654321";
final uri = controller.generateAuthorizeLinkWithCodeChallenge(codeChallenge: codeChallenge, redirectUri: redirectUri);
```

5. Web with code_challenge and default redirect_uri 
```dart
final controller = VkIDController(clID: 1234567890);
//Generate code_verifier and code_challenge itself or get code_challenge from back-end
final codeChallenge = "1234567890RND0987654321";
final uri = controller.generateAuthorizeLinkWithCodeChallenge(codeChallenge: codeChallenge);
```

6. Web with random code_verifier and user-defined redirect_uri from VK web app settings
```dart
final controller = VkIDController(clID: 1234567890);
final redirectUri = "https://site.com/redirect";
//Generate code_verifier
final codeVerifier = "1234567890RND0987654321";
final codeVerifierWithUri = controller.generateAuthorizeLinkWithCodeVerifier(codeVerifier: codeVerifier);
```

7. Web with random code_verifier and default redirect_uri
```dart
final controller = VkIDController(clID: 1234567890);
//Generate code_verifier
final codeVerifier = "1234567890RND0987654321";
final codeVerifierWithUri = controller.generateAuthorizeLinkWithCodeVerifier(codeVerifier: codeVerifier);
```

### Authorizing on VK ID

**You need flutter context and webview to handle it**

Pass authorize link to webview. Also include NavigationDelegate for preventing redirect navigation requests. See [example](./example/lib/ui/oauth_screen_mobile.dart) for details
On success authorization you will be redirected by uri from redirect_uri + query parameters

- Front-end mode: Block redirect from id.vk.com on webview context (Prevent navigation request). Also you need extract 'code' and 'device_id' parameters from query for exchanging OAuth token
- Back-end mode: If VK app is web, don't block redirect. Otherwise block it and process authorization data

### Retrieve OAuth token

- Front-end mode: Use controller method to exchange authorization_code for access_token
- Back-end mode: Send, if needed, data to back-end for exchanging

**VK ID controller refreshes the access token itself if necessary**



