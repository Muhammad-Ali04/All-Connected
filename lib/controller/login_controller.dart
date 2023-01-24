import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter valid data";
    } else if (!GetUtils.isEmail(value)) {
      return "Enter Your Correct Email";
    }
  }

  passwordValidate(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == null || value.isEmpty) {
      return "Please Enter valid data";
    } else if (!regex.hasMatch(value)) {
      return "Enter Correct Password";
    }
  }

  onPressed() async {
    bool status = await Auth.LoginUser(
        email: emailController.text, password: passwordController.text);
    if (status == true) {
      Get.to(HomeScreen(), transition: Transition.circularReveal);
      Get.snackbar("Login", "Login Successfully");
    } else
      Get.snackbar("", "Login failed",
          duration: Duration(seconds: 1),
          dismissDirection: DismissDirection.down);
  }

  clearEmail() {
    emailController.clear();
  }

  clearPassword() {
    passwordController.clear();
  }
}
