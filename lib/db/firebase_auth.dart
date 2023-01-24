import 'package:exd_social_app/screens/login_screen.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../screens/chat/login.dart';

class Auth {
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference postRefernce =
      FirebaseFirestore.instance.collection('posts');
  static Future SignupUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String imageUrl,
  }) async {
    bool status = false;

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? currentUser = credential.user;

      if (currentUser != null) {
        DocumentReference currentUserRefernce =
            userReference.doc(currentUser.uid);
        Map<String, dynamic> userProfiledata = {
          // "name": name,
          "email": email,
          "phone": phoneNumber,
          "uid": currentUser.uid,
        };

        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
              imageUrl: imageUrl,
              firstName: name,
              id: credential.user!.uid,
              metadata: userProfiledata),
        );

        // await currentUserRefernce.set(userProfiledata);
      }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return status;
  }

  static Future LoginUser({
    required String email,
    required String password,
  }) async {
    bool status = false;

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that Email.");
      } else if (e.code == "wrong-password") {
        print("wrong passowrd provided for that user");
      }
    } catch (e) {
      print(e);
    }
    return status;
  }

  static Future Logout() async {
    await FirebaseAuth.instance.signOut();
    Get.to(LoginScreen());
  }
}
