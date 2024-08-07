
import 'dart:io';

import 'package:example/ui/oauth_screen_desktop.dart';
import 'package:example/ui/oauth_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:vk_id/vk_id.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _vkidController = VkIDController(clID: 52039838);
  final _redirectUriTextController = TextEditingController();
  Uri? _authorizeUri;
  final _authorizeUriTextController = TextEditingController();
  var _codeVerifier = "";

  final _accessTkTextController = TextEditingController();
  final _profileNameTextController = TextEditingController();

  final _apiErrNotifier = ValueNotifier<String>("");

  void _generateAuthorizeLink() {
    final pair = _vkidController.generateAuthorizeLinkWithCodeVerifier(redirectUri: _redirectUriTextController.text);
    final uri = pair.value;
    if (uri == null) {
      return;
    }
    _authorizeUri = uri;
    _codeVerifier = pair.key;
    _authorizeUriTextController.text = uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Stack(children: [
      ListView(shrinkWrap: true, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), children: [
        Align(alignment: Alignment.centerLeft, child: Text("VK client ID: " + _vkidController.clID.toString())),
        const Padding(padding: EdgeInsets.only(top: 8)),
        TextField(decoration: const InputDecoration(hintText: "Redirect Uri"), controller: _redirectUriTextController),
        const Padding(padding: EdgeInsets.only(top: 8)),
        TextField(decoration: const InputDecoration(hintText: "Generated authorize link"), controller: _authorizeUriTextController, readOnly: true),
        Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _generateAuthorizeLink,
            child: const Text("Re-generate authorize link"))),
        const Padding(padding: EdgeInsets.only(top: 24)),
        const Text("Authorization data"),
        const Padding(padding: EdgeInsets.only(top: 8)),
        TextField(decoration: const InputDecoration(hintText: "Access token"), controller: _accessTkTextController, readOnly: true),
        const Padding(padding: EdgeInsets.only(top: 8)),
        TextField(decoration: const InputDecoration(hintText: "Profile info"), controller: _profileNameTextController, readOnly: true),
        const Padding(padding: EdgeInsets.only(top: 48))
      ],),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.only(bottom: 16), child: TextButton(onPressed: () async {
        _apiErrNotifier.value = "";
        if (_authorizeUri == null) {
          _generateAuthorizeLink();
        }
        final uri = _authorizeUri;
        if (uri == null) {
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          final callback = (String code, String deviceId) async {
            final authRes = await _vkidController.retrieveOAuthToken(authorizationCode: code, deviceId: deviceId, codeVerifier: _codeVerifier, state: uri.queryParameters["state"] ?? "");
            final auth = authRes.result;
            if (auth == null) {
              var msg = "Retrieve OAuth token error";
              final err = authRes.error?.vkErr;
              if (err != null) {
                msg += ": " + err.error + " - " + err.description;
              }
              _apiErrNotifier.value = msg;
              return;
            }
            _accessTkTextController.text = authRes.result?.accessToken ?? "";
            final profileRes = await _vkidController.getProfileInfo();
            final profile = profileRes.result;
            if (profile == null) {
              var msg = "Profile info load error";
              final err = profileRes.error?.vkErr;
              if (err != null) {
                msg += ": " + err.error + " - " + err.description;
              }
              _apiErrNotifier.value = msg;
              return;
            }
            _profileNameTextController.text = profile.userId.toString() + " - " + profile.firstName + ' ' + profile.lastName;
          };
          if (Platform.isIOS || Platform.isAndroid) {
            return OAuthScreenMobile(authUri: uri, authCallback: callback);
          }
          return OAuthScreenDesktop(authUri: uri, authCallback: callback);
        }));
      }, child: const Text("Auth"))))
    ])));
  }
}