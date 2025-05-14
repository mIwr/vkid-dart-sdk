
import 'vk_err_type.dart';

///VK Error
class VkErr extends Error {

  ///Field name with error or error type key
  final String error;
  ///Parsed form error type key
  VkErrType? get parsedErrorType {
    return VkErrTypeExt.from(error);
  }
  ///Error description
  final String description;

  ///VK error ctor
  VkErr({required this.error, required this.description});

  ///Tries to parse the instance from JSON
  static VkErr? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("error") && !jsonMap.containsKey("error_description")) {
      return null;
    }
    final String fieldName = jsonMap["error"] ?? "";
    final String desc = jsonMap["error_description"] ?? "";
    return VkErr(error: fieldName, description: desc);
  }
}