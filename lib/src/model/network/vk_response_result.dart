
import 'vk_response_err.dart';
import '../vk_result.dart';

///Represents abstract VK ID API response result
class VkResponseResult<T> extends VkResult<T,VkResponseErr> {

  ///Abstract VK ID API response result ctor
  const VkResponseResult({super.result, super.error});
}