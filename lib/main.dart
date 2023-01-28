import 'package:exd_social_app/screens/chat/chat.dart';
import 'package:exd_social_app/screens/chat/login.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/loaction_screen.dart';
import 'package:exd_social_app/screens/login_screen.dart';
import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:exd_social_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCMToken : $token");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await getFCMToken();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        Map<String, dynamic> data = message.data;
        Get.snackbar(
          onTap: (snack) {
            if (data["isNotify"] == 0) {
              Get.to(ChatPage(
                room: data["room"],
              ));
            }
          },
          "${message.notification!.title.toString()}",
          "${message.notification!.body.toString()}",
        );

        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.transparent,
      // ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
