import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController {
  File? profilepic;
  CroppedFile? profileCrop;
  late String imageUrl = '';

  User? currentUser = FirebaseAuth.instance.currentUser;

  profilePickAndCrop() async {
    final ImagePicker _profilepick = ImagePicker();

    final XFile? profileCam = await _profilepick.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    profileCrop = await ImageCropper().cropImage(
      sourcePath: profileCam!.path,
    );

    if (profileCrop != null) {
      profilepic = File(profileCrop!.path);
      update();
    }

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    File? filePath = File(profilepic!.path);

    try {
      firebase_storage.UploadTask? uploadPic;
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("ProfilePic")
          .child("/$imageName");

      uploadPic = reference.putFile(filePath);
      Future.value(uploadPic).then(
        (value) async {
          imageUrl = await reference.getDownloadURL();
          print(imageUrl);

          String? uid;

          uid = currentUser!.uid;

          DocumentReference user =
              FirebaseFirestore.instance.collection("users").doc(uid);
          await user.update({"imageUrl": imageUrl});
        },
      );
    } catch (e) {}
  }

  // getProfileImage() {

  // }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  nameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Your Name Please";
    }
  }

  emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter valid data";
    } else if (!GetUtils.isEmail(value)) {
      return "Enter Your Correct Emial";
    }
  }

  passwordValidate(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == null || value.isEmpty) {
      return "Please Enter valid data";
    } else if (!regex.hasMatch(value)) {
      return "Enter Strong Password e.g(Abc@123_)";
    }
  }

  phoneValidate(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp phone = new RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Please Enter Valid data";
    } else if (!phone.hasMatch(value)) {
      return "Please Enter Correct Number";
    }
  }

  onPressed() {
    var status = Auth.SignupUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: phoneController.text,
        imageUrl: imageUrl);

    Get.snackbar("SignUp", "SuccessFully SignUp");
  }

  clearEmail() {
    emailController.clear();
  }

  clearPassword() {
    passwordController.clear();
  }

  clearName() {
    nameController.clear();
  }

  clearPhoneNumber() {
    phoneController.clear();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
