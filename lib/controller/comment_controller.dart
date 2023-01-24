import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/models/comments_model.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;

class CreateCommentController extends GetxController {
  File? commentImage;
  CroppedFile? commentCropImage;
  String commentImageUrl = '';
  User? currentuser = FirebaseAuth.instance.currentUser;
  var commentController = TextEditingController();

  commentImagePickerGallery() async {
    final ImagePicker _imagepicker = ImagePicker();

    final XFile? postPath = await _imagepicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    commentCropImage =
        await ImageCropper().cropImage(sourcePath: postPath!.path);

    if (commentCropImage != null) {
      commentImage = File(commentCropImage!.path);
      update();
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      File? postFilepath = File(commentImage!.path);
      try {
        fire_storage.UploadTask? uploadtask;
        fire_storage.Reference reference = fire_storage.FirebaseStorage.instance
            .ref()
            .child("commentImages")
            .child("/$imageName");

        uploadtask = reference.putFile(postFilepath);
        Future.value(uploadtask).then(
          (value) async {
            commentImageUrl = await reference.getDownloadURL();
            print(commentImageUrl);

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

  // Future addComments() async {
  //   CollectionReference comments =
  //       FirebaseFirestore.instance.collection('comments');
  //   CollectionReference postRef =
  //       FirebaseFirestore.instance.collection('posts');
  //   DocumentSnapshot user =
  //       await Auth.userReference.doc(currentuser!.uid).get();
  //   UserModel userData =
  //       UserModel.fromjson(user.data() as Map<String, dynamic>);

  //   DocumentSnapshot post = await postRef.doc().get();

  //   PostModel postDetail =
  //       PostModel.fromjson(post.data() as Map<String, dynamic>);
  //   CommentsModel commentData = CommentsModel.withoutId(
  //     username: userData.name,
  //     uid: userData.userId,
  //     commentText: commentController.text,
  //     commentImage: commentImageUrl,
  //     dateTime: DateTime.now().toString(),
  //     userImage: userData.profilePic,
  //     docId: postDetail.id,
  //   );

  //   await comments
  //       .add(commentData.toJson())
  //       .then((value) => "Done")
  //       .onError((error, stackTrace) => "Error");
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
