
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuthScreenMobile extends StatefulWidget {
  
  final Uri authUri;
  final void Function(String code, String deviceID) authCallback;

  final Widget? closeButton;
  final EdgeInsets closeButtonPadding;
  final Alignment closeButtonAlignment;

  const OAuthScreenMobile({super.key, required this.authUri, required this.authCallback, this.closeButton, this.closeButtonPadding = const EdgeInsets.fromLTRB(16, 0, 16, 16), this.closeButtonAlignment = Alignment.bottomCenter});

  @override
  State createState() => _OAuthScreenMobileState();
}

class _OAuthScreenMobileState extends State<OAuthScreenMobile> {

  var _redirectUri = "";
  final _webViewController = WebViewController();
  var _authorized = false;

  @override
  void initState() {
    super.initState();
    _redirectUri = widget.authUri.queryParameters["redirect_uri"] ?? "";
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setBackgroundColor(Colors.transparent);
    _webViewController.setNavigationDelegate(NavigationDelegate(onNavigationRequest: _onNavigationRequest));
    _webViewController.loadRequest(widget.authUri);
  }

  @override
  void dispose() {
    super.dispose();
    _webViewController.clearCache();
    _webViewController.clearLocalStorage();
  }

  NavigationDecision _onNavigationRequest(NavigationRequest req) {
    if (!mounted) {
      return NavigationDecision.prevent;
    }
    if (_redirectUri.isNotEmpty && req.url.startsWith(_redirectUri)) {
      if (_authorized) {
        return NavigationDecision.prevent;
      }
      final authorizeUri = Uri.tryParse(req.url);
      if (authorizeUri == null) {
        if (kDebugMode) {
          print("Unable to parse authorization data - Invalid request URL '" + req.url + '\'');
        }
        return NavigationDecision.prevent;
      }
      _authorized = true;
      final code = authorizeUri.queryParameters["code"] ?? "";
      final deviceId = authorizeUri.queryParameters["device_id"] ?? "";
      widget.authCallback(code, deviceId);
      final stateContext = context;
      if (!stateContext.mounted) {
        return NavigationDecision.prevent;
      }
      Navigator.of(stateContext).pop();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(body: SafeArea(bottom: false, child: Stack(children: [
      SizedBox(height: mediaQuery.size.height, width: mediaQuery.size.width,
          child: WebViewWidget(controller: _webViewController)),
      Align(alignment: widget.closeButtonAlignment, child: Padding(padding: widget.closeButtonPadding,child: widget.closeButton))
    ],)));
  }
}