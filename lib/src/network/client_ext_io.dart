import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../global_constants.dart';
import 'client.dart';
import '../model/network/vk_err.dart';
import '../model/network/vk_response_result.dart';
import '../model/network/vk_response_err.dart';
import '../model/network/vk_api_function.dart';

///HTTP client IO extension
extension ClientExt on Client {

  ///Initialize platform-specific HTTP client
  static http.Client stubCtor() {
    final httpClient = HttpClient();
    httpClient.autoUncompress = true;
    httpClient.badCertificateCallback = _certValidator;
    return IOClient(httpClient);
  }

  ///SSL cert validator
  static bool _certValidator(X509Certificate? cert, String host, int port) {
    if (cert == null) {
      return true;
    }
    if (kDartDebugMode) {
      print("Bad cert: host " + host + ", port " + port.toString() + ". Cert info: issuer " + cert.issuer + "; subject " + cert.subject);
    }
    var certDigest = "";
    for (final element in cert.sha1) {
      certDigest += element.toRadixString(16);
    }
    if (kDartDebugMode) {
      print("Cert SHA1: " + certDigest.toUpperCase() + ". Valid thru: " + cert.endValidity.toIso8601String());
    }

    return true;
  }

  ///Handle platform-specific response errors
  VkResponseResult<dynamic>? stubResponseErrProcess(Object ex, {VkApiFunction? func}) {
    if (ex is HandshakeException) {
      final HandshakeException error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "bad_cert", description: error.type + " - " + error.message)));
    }
    if (ex is HttpException) {
      final HttpException error = ex;
      return VkResponseResult(error: VkResponseErr(statusCode: -1, vkErr: VkErr(error: "-", description: "Http exception: " + error.message)));
    }
    return null;
  }
}