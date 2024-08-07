
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OAuthScreenDesktop extends StatefulWidget {

  final Uri authUri;
  final void Function(String code, String deviceID) authCallback;

  final Widget? closeButton;
  final EdgeInsets closeButtonPadding;
  final Alignment closeButtonAlignment;

  const OAuthScreenDesktop({super.key, required this.authUri, required this.authCallback, this.closeButton, this.closeButtonPadding = const EdgeInsets.fromLTRB(16, 0, 16, 16), this.closeButtonAlignment = Alignment.bottomCenter});

  @override
  State createState() => _OAuthScreenDesktopState();

}

class _OAuthScreenDesktopState extends State<OAuthScreenDesktop> {

  var _redirectUri = "";
  Webview? _webview;
  var _authorized = false;

  @override
  void initState() {
    super.initState();
    _redirectUri = widget.authUri.queryParameters["redirect_uri"] ?? "";
    WebviewWindow.create().then((value) {
      _webview = value;
      _webview?.onClose.then((value) {
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pop();
      });
      _webview?.addOnUrlRequestCallback((url) {
        if (_authorized || _redirectUri.isEmpty || !url.startsWith(_redirectUri)) {
          return;
        }
        final authorizeUri = Uri.tryParse(url);
        if (authorizeUri == null) {
          if (kDebugMode) {
            print("Unable to parse authorization data - Invalid request URL '" + url + '\'');
          }
          return;
        }
        _authorized = true;
        final code = authorizeUri.queryParameters["code"] ?? "";
        final deviceId = authorizeUri.queryParameters["device_id"] ?? "";
        widget.authCallback(code, deviceId);
        final stateContext = context;
        if (!stateContext.mounted) {
          return;
        }
        Navigator.of(stateContext).pop();
        _webview?.close();
      });
      _webview?.launch(widget.authUri.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _webview?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(bottom: false, child: Stack(children: [
      Align(alignment: widget.closeButtonAlignment, child: Padding(padding: widget.closeButtonPadding,child: widget.closeButton ?? TextButton(onPressed: () {
        _webview?.close();
        _webview = null;
        Navigator.of(context).pop();
      }, child: const Text("Close"))))
    ],)));
  }
}