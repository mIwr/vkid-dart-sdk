import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'model/vk_err.dart';
import 'model/vk_response_result.dart';
import 'model/vk_response_err.dart';
import 'model/vk_api_function.dart';

///Represents low-level network API interacting with IO support
class Client {

  ///HTTP IO client
  var _httpClient = IOClient();
  ///VK ID API base URL
  var _baseUrl = "";
  ///VK ID API base URL
  String get baseUrl => _baseUrl;

  ///Error response events controller
  final StreamController<VkResponseErr> _apiErrorEventsController = StreamController.broadcast();
  ///Error response events stream
  Stream<VkResponseErr> get onApiError => _apiErrorEventsController.stream;
  ///Logout error response events controller
  final StreamController<void> _apiLogoutEventsController = StreamController.broadcast();
  ///Logout error response events stream
  Stream<void> get onApiLogout => _apiLogoutEventsController.stream;

  Client({required String baseUrl}) {
    _baseUrl = baseUrl;
    final httpClient = HttpClient();
    httpClient.autoUncompress = true;
    httpClient.badCertificateCallback = _certValidator;
    _httpClient = IOClient(httpClient);
  }

  ///Updates VK ID base URL
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
      path = path.substring(0, path.length - 1);
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

  ///SSL cert validator
  bool _certValidator(X509Certificate? cert, String host, int port) {
    if (cert == null) {
      return true;
    }
    print("Bad cert: host " + host + ", port " + port.toString() +
        ". Cert info: issuer " + cert.issuer + "; subject " + cert.subject);
    String certDigest = "";
    for (final element in cert.sha1) {
      certDigest += element.toRadixString(16);
    }
    print("Cert SHA1: " + certDigest.toUpperCase() + ". Valid thru: " + cert.endValidity.toIso8601String());

    return true;
  }

  ///Low-level response handler
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
    if (ex is HandshakeException) {
      final HandshakeException error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "bad_cert", description: error.type + " - " + error.message)));
    }
    if (ex is HttpException) {
      final HttpException error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Http exception: " + error.message)));
    }
    if (ex is http.ClientException) {
      final error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Http exception: " + error.message)));
    }

    return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Unknown error")));
  }
}