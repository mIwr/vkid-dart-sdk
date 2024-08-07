
///API function payload
class VkApiFunction {

  ///Overridden API base url
  final String baseUrl;
  ///API url path
  final String path;
  ///Request method
  final String method;
  ///Request headers
  final Map<String, String>? headers;
  ///Request query parameters
  final Map<String, String>? queryParams;
  ///Request body map
  final Map<String, String>? formData;

  const VkApiFunction({this.baseUrl = "", required this.path, required this.method, this.headers, this.queryParams, this.formData});

  @override
  String toString() {
    var res = method + " " + baseUrl + path;
    final params = queryParams;
    if (params != null && params.isNotEmpty) {
      var query = "?";
      for (final entry in params.entries) {
        query += entry.key + '=' + entry.value.toString() + '&';
      }
      query = query.substring(0, query.length - 1);
    }
    return res;
  }
}