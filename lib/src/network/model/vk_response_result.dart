
import 'vk_response_err.dart';
import '../../model/vk_result.dart';

///Represents abstract VK ID API response result
class VkResponseResult<T> extends VkResult<T,VkResponseErr> {

  const VkResponseResult({super.result, super.error});
}