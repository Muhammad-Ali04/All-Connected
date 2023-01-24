import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'chat.dart';

import 'login.dart';
import 'users.dart';
import 'util.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff182848),
        automaticallyImplyLeading: false,
        shadowColor: Color(0xff182848),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xff182848),
            statusBarIconBrightness: Brightness.light),
        actions: [
          IconButton(
            icon: const Icon(Icons.add,
                color: Color.fromARGB(255, 178, 190, 218)),
            onPressed: _user == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const UsersPage(),
                      ),
                    );
                  },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Color.fromARGB(255, 178, 190, 218),
        ),
        title: const Text(
          'Chats',
          style: TextStyle(fontFamily: "Ubuntu"),
        ),
      ),
      body: _user == null
          ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                bottom: height * 0.2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tap + Button For New Chat'),
                ],
              ),
            )
          : StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      bottom: height * 0.2,
                    ),
                    child: Text('No rooms'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              room: room,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: width * 0.05,
                            right: width * 0.05,
                            top: height * 0.02),
                        width: width,
                        height: height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 2)
                          ],
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            _buildAvatar(room),
                            Text(
                              room.name ?? '',
                              style: TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Center()),
                            Container(
                                padding: EdgeInsets.only(right: width * 0.02),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color.fromARGB(255, 178, 190, 218),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform
          );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.04),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty
                    ? ''
                    : name[0].toUpperCase() + name[1].toLowerCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
