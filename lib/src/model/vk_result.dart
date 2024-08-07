
///Represents abstract result with positive (data) and negative (error) variants
class VkResult<T,X extends Error>  {

  ///Payload data
  final T? result;
  ///Error
  final X? error;

  ///Success flag
  ///
  ///Means that instance contains only the payload data without error
  bool get success => error == null && result != null;

  const VkResult({this.result, this.error});
}