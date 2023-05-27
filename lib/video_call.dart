// ignore_for_file: must_be_immutable, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_const_constructors
import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class VideoCall extends StatefulWidget {
  String channelName = "test";

  VideoCall({required this.channelName});
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient _client;
  bool _loading = true;
  String tempToken =
      "006cd3fc095ad8c45218f24594a70876192 IAD63hxyNZBp7giIb6Bip9qHn8fsdoT79Z7uuabyVaKLjgx+f9gAAAAAEABuTAVHOiVzZAEAAQDK4XFk";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    String link =
        "https://agora-node-tokenserver-1.chetanakkatange.repl.co/access_token?channelName=${widget.channelName}";

    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    setState(() {
      tempToken = data["token"];
    });
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "cd3fc095ad8c45218f24594a70876192",
          tempToken: tempToken,
          channelName: widget.channelName,
        ),
        enabledPermission: [Permission.camera, Permission.microphone]);
    Future.delayed(Duration(seconds: 1)).then(
      (value) => setState(() => _loading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    client: _client,
                  ),
                  AgoraVideoButtons(client: _client)
                ],
              ),
      ),
    );
  }
}
