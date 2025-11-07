
import 'package:vk_id/vk_id.dart';

abstract class TestConstants {

  static const kClientID = 1234567890;
  static const kRedirectUri = "https://site.com/redirect";

  static const kDummyOAuthTokenResponse = VkResponseResult(result: {
    "refresh_token": "refresh_token_value",
    "access_token": "access_token_value",
    "id_token": "id_token_value",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user_id": 12345678,
    "state": "XXFGXrandomZZFD",
    "scope": "email phone"
  });

  static const kDummyRefreshOAuthTokenResponse = VkResponseResult(result: {
    "refresh_token": "refresh_token_value",
    "access_token": "access_token_value",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user_id": 12345678,
    "state": "XXFGXrandomZZFD",
    "scope": "email phone"
  });

  static const kDummyMaskedProfileInfoResponse = VkResponseResult(result: {
    "user": {
      "user_id": "12345678",
      "first_name": "firstName",
      "last_name": "L.",
      "phone": "+7900 *** ** 29",
      "avatar": "https://pp.userapi.com/60tZWMo4SmwcploUVl9XEt8ufnTTvDUmQ6Bj1g/mmv1pcj63C4.png",
      "email": ""
    }
  });

  static const kDummyProfileInfoResponse = VkResponseResult(result: {
    "user": {
      "user_id": "12345678",
      "first_name": "firstName",
      "last_name": "lastName",
      "phone": "79003922415",
      "avatar": "https://pp.userapi.com/60tZWMo4SmwcploUVl9XEt8ufnTTvDUmQ6Bj1g/mmv1pcj63C4.png",
      "email": "ivan_i123@vk.com",
      "sex": 2,
      "verified": false,
      "birthday": "01.01.2000"
    }
  });
}