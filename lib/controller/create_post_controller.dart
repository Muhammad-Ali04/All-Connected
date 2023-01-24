import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostController extends GetxController {
  var textpost = TextEditingController();

  File? postimage;
  CroppedFile? postcropimage;
  String postimageurl = "";

  User? currentuser = FirebaseAuth.instance.currentUser;

  PostImagePickerCamera() async {
    final ImagePicker _imagepicker = ImagePicker();

    final XFile? postPath = await _imagepicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);

    postcropimage = await ImageCropper().cropImage(sourcePath: postPath!.path);

    if (postcropimage != null) {
      postimage = File(postcropimage!.path);
      update();
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      File? postFilepath = File(postimage!.path);
      try {
        fire_storage.UploadTask? uploadtask;
        fire_storage.Reference reference = fire_storage.FirebaseStorage.instance
            .ref()
            .child("postImages")
            .child("/$imageName");

        uploadtask = reference.putFile(postFilepath);
        Future.value(uploadtask).then(
          (value) async {
            postimageurl = await reference.getDownloadURL();
            print(postimageurl);
            update();

            //   String? uid;

            // uid = currentuser!.uid;

            // DocumentReference post =
            //     FirebaseFirestore.instance.collection('post').doc(uid);

            // await post.update({"postImage": postimageurl});
          },
        );
      } catch (e) {}
    }
  }

  PostImagePickerGallery() async {
    final ImagePicker _imagepicker = ImagePicker();

    final XFile? postPath = await _imagepicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    postcropimage = await ImageCropper().cropImage(sourcePath: postPath!.path);

    if (postcropimage != null) {
      postimage = File(postcropimage!.path);
      update();
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      File? postFilepath = File(postimage!.path);
      try {
        fire_storage.UploadTask? uploadtask;
        fire_storage.Reference reference = fire_storage.FirebaseStorage.instance
            .ref()
            .child("postImages")
            .child("/$imageName");

        uploadtask = reference.putFile(postFilepath);
        Future.value(uploadtask).then(
          (value) async {
            postimageurl = await reference.getDownloadURL();
            print(postimageurl);

            //   String? uid;
            update();

            // uid = currentuser!.uid;

            // DocumentReference post =
            //     FirebaseFirestore.instance.collection('post').doc(uid);

            // await post.update({"postImage": postimageurl});
          },
        );
      } catch (e) {}
    }
  }

  Future adddPost() async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    CollectionReference post = FirebaseFirestore.instance.collection('posts');
    DocumentSnapshot user = await userReference.doc(currentuser!.uid).get();
    UserModel data = UserModel.fromjson(user.data() as Map<String, dynamic>);

    PostModel postData = PostModel.withoutId(
        postText: textpost.text,
        userImage: data.imageUrl,
        postImage: postimageurl,
        dateTime: DateTime.now().toString(),
        username: data.name,
        uid: user.id);

    await post
        .add(postData.toJson())
        .then((value) => "done")
        .onError((error, stackTrace) => "Error");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
