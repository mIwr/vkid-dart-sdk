import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/vk_err.dart';
import 'model/vk_response_result.dart';
import 'model/vk_response_err.dart';
import 'model/vk_api_function.dart';

///Represents low-level network API interacting
class Client {
  final _httpClient = http.Client();
  var _baseUrl = "";
  ///Back-end API base URL
  String get baseUrl => _baseUrl;

  final StreamController<VkResponseErr> _apiErrorEventsController = StreamController.broadcast();
  Stream<VkResponseErr> get onApiError => _apiErrorEventsController.stream;
  final StreamController<void> _apiLogoutEventsController = StreamController.broadcast();
  Stream<void> get onApiLogout => _apiLogoutEventsController.stream;

  Client({required String baseUrl}) {
    _baseUrl = baseUrl;
  }

  bool updateBaseUrl(String urlString) {
    if (urlString.isEmpty) {
      return false;
    }
    _baseUrl = urlString;

    return true;
  }

  ///Send request with API function
  ///
  ///[func] - API function
  ///Returns response data
  Future<VkResponseResult<dynamic>> sendAsync(VkApiFunction func) async {
    final req = _prepare(func);
    try {
      final response = await _httpClient.send(req);
      return await _processResponse(response, func: func);
    } catch (ex) {
      return _processResponseErr(ex, func: func);
    }
  }

  ///Prepares request
  ///
  ///[apiFunc] - API function
  http.Request _prepare(VkApiFunction apiFunc) {
    var baseUrl = this.baseUrl;
    if (baseUrl.isEmpty || apiFunc.baseUrl.isNotEmpty) {
      baseUrl = apiFunc.baseUrl;
    }
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    var path = apiFunc.path;
    if (path.startsWith('/')) {
      path = path.substring(0, baseUrl.length - 1);
    }
    final funcHeaders = apiFunc.headers;
    final formDataMap = apiFunc.formData;

    final uri = Uri(scheme: "https", host: baseUrl.replaceAll("https://", ""), path: path, queryParameters: apiFunc.queryParams);
    final req = http.Request(apiFunc.method, uri);
    if (funcHeaders != null && funcHeaders.isNotEmpty) {
      req.headers.addAll(funcHeaders);
    }
    if (formDataMap != null && formDataMap.isNotEmpty) {
      req.bodyFields = formDataMap;
    }

    return req;
  }

  Future<VkResponseResult<dynamic>> _processResponse(http.StreamedResponse response, {VkApiFunction? func}) async {
    try {
      final data = await response.stream.bytesToString();
      final Map<String, dynamic> jsonDict = json.decode(data);
      final err = VkErr.from(jsonDict);
      return VkResponseResult(result: jsonDict, error: err == null
          ? null
          : VkResponseErr(statusCode: response.statusCode, vkErr: err));
    } catch (ex) {
      return _processResponseErr(ex, func: func);
    }
  }



  ///Parses response error
  ///
  /// [ex] Error instance
  VkResponseResult<dynamic> _processResponseErr(Object ex, {VkApiFunction? func}) {
    if (ex is TimeoutException) {
      final TimeoutException error = ex;
      var msg = "Timeout exception";
      final duration = error.duration;
      if (duration != null) {
        msg += " (" + duration.inSeconds.toString() + " secs)";
      }
      final errMsg = error.message;
      if (errMsg != null && errMsg.isNotEmpty) {
        msg += ": " + errMsg;
      }
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: msg)));
    }
    if (ex is http.ClientException) {
      final error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Http exception: " + error.message)));
    }

    return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Unknown error")));
  }
}