
import 'vk_err.dart';

///VK ID response error
class VkResponseErr extends Error {

  ///HTTP response status code
  final int statusCode;
  ///VK ID API error
  final VkErr? vkErr;

  ///VK ID response error ctor
  VkResponseErr({required this.statusCode, this.vkErr});
}