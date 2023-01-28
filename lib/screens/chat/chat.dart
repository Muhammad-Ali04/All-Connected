import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'agora_screen.dart';

class ChatPage extends StatefulWidget {
  final types.Room room;
  ChatPage({
    super.key,
    required this.room,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  String AuthKey =
      "key=AAAAZnRLdl0:APA91bH4JySFVZHAO8x7K65XJrPf3_el2p-drNECBnjcB-7kChjMN9fGzeweXxTROLQ36PVoGqmwQjPCEzMj8jUQruAcvwDS2wrwcUeahGcdqCgWe6msnjboMbO4sYFJ-00jv9f86Nz8";

  String token =
      "eusmXktzQ8O9j4RKQl1RRg:APA91bEM627J_pjNxzMSyKO0VZqbzW82CuUeiVZ0fcSiSlcr_-CfhR2O5msreS02mwUkwaGk2thKvky2wqABGbBoeneE6RsjoHzrKK1BFqzePaY6fgN_Dp-hj0u62uw5IibkRBFacsup";

  String otherUserToken =
      "eusmXktzQ8O9j4RKQl1RRg:APA91bEM627J_pjNxzMSyKO0VZqbzW82CuUeiVZ0fcSiSlcr_-CfhR2O5msreS02mwUkwaGk2thKvky2wqABGbBoeneE6RsjoHzrKK1BFqzePaY6fgN_Dp-hj0u62uw5IibkRBFacsup";

  Future<void> meassageNotification() async {
    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map<String, dynamic> body = {
      "to": token,
      "notification": {
        "title": widget.room.name.toString().capitalize,
        "body": "New Notification"
      },
      "data": <String, dynamic>{
        "room": widget.room,
        "title": "Title of Notification",
        "isNOtify": 0
      }
    };
    http.Response response = await http.post(uri,
        body: jsonEncode(body),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": AuthKey
        });
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff182848),
          automaticallyImplyLeading: false,
          shadowColor: Color(0xff182848),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xff182848),
              statusBarIconBrightness: Brightness.light),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              color: Color.fromARGB(255, 178, 190, 218)),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.phone_fill),
                color: Color.fromARGB(255, 178, 190, 218)),
            IconButton(
                onPressed: () {
                  Get.to(AgoraScreen(
                    room: widget.room,
                  ));
                },
                icon: Icon(CupertinoIcons.videocam_fill),
                color: Color.fromARGB(255, 178, 190, 218))
          ],
          title: Text(
            widget.room.name.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => Chat(
              showUserAvatars: true,
              showUserNames: true,
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            ),
          ),
        ),
      );

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async {
    await meassageNotification();
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}
