import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileController extends GetxController {
  File? coverPic;
  CroppedFile? covereCrop;
  late final String coverImageUrl;

  User? currentUser = FirebaseAuth.instance.currentUser;

  coverPicPickerAndCrop() async {
    final ImagePicker _coverPicker = ImagePicker();

    final XFile? coverCam = await _coverPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    covereCrop = await ImageCropper().cropImage(sourcePath: coverCam!.path);

    if (covereCrop != null) {
      coverPic = File(covereCrop!.path);
      update();

      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      File? filePath = File(coverPic!.path);

      try {
        firebase_storage.UploadTask? uploadPic;
        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("coverPic")
            .child("/$imageName");

        uploadPic = reference.putFile(filePath);
        Future.value(uploadPic).then(
          (value) async {
            coverImageUrl = await reference.getDownloadURL();
            print(coverImageUrl);

            String? uid;

            uid = currentUser!.uid;

            DocumentReference user =
                FirebaseFirestore.instance.collection("users").doc(uid);
            await user.update({"coverPic": coverImageUrl});
          },
        );
      } catch (e) {}
    }
  }

  // getCoverPic() {

  // }
}
