import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AgoraScreen extends StatefulWidget {
  final types.Room room;
  const AgoraScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  AgoraClient? client;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "e65f752113ae46eebf2a1b9cbe182454",
          channelName: widget.room.id,
          username: "user",
        ),
        enabledPermission: [Permission.camera, Permission.microphone]);

    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client!,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client!,
            ),
          ],
        ),
      ),
    );
  }
}
