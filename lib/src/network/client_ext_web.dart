import 'package:http/http.dart' as http;

import 'client.dart';
import '../model/network/vk_response_result.dart';
import '../model/network/vk_api_function.dart';

///HTTP client WEB extension
extension ClientExt on Client {

  ///Initialize platform-specific HTTP client
  static http.Client stubCtor() {
    return http.Client();
  }

  ///Handle platform-specific response errors
  VkResponseResult<dynamic>? stubResponseErrProcess(Object ex, {VkApiFunction? func}) {
    return null;
  }
}