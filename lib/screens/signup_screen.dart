import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:exd_social_app/controller/signup_controller.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // SignupController signupController = Get.put(SignupController());
  @override
  GlobalKey<FormState> _formkey = GlobalKey();

  bool _paaswordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    // final _formkey = GlobalKey<FormState>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<SignupController>(
            init: SignupController(),
            initState: (_) {},
            builder: (_) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.03, left: width * 0.03),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            cursor: '',
                            curve: Curves.fastOutSlowIn,
                            speed: Duration(milliseconds: 200),
                            'All Connected',
                            textStyle: TextStyle(
                                fontFamily: "Ubuntu",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = LinearGradient(colors: <Color>[
                                    Color(0xff4B6CB7),
                                    Color.fromARGB(255, 0, 0, 0),
                                  ]).createShader(
                                      Rect.fromLTWH(30.0, 30.0, 50.0, 50.0))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(children: [
                            _.profilepic != null
                                ? Container(
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundColor:
                                          Color.fromARGB(255, 0, 0, 0),
                                      child: CircleAvatar(
                                        radius: 57,
                                        backgroundImage:
                                            FileImage(_.profilepic!),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundColor:
                                          Color.fromARGB(255, 0, 0, 0),
                                      child: CircleAvatar(
                                        radius: 57,
                                        backgroundImage: AssetImage(
                                            "assets/images/person.jpeg"),
                                      ),
                                    ),
                                  ),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                await _.profilePickAndCrop();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.24, top: height * 0.1),
                                height: height * 0.03,
                                width: width * 0.07,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(116, 75, 107, 183),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Icon(
                                  CupertinoIcons.pen,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    //All Text Feilds
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.13, right: width * 0.13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        color: Color(0xff182848),
                                        offset: Offset(0, 0),
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _.nameController,
                                validator: (value) => _.nameValidate(value),
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 193, 39, 28),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 193, 39, 28)),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xff4B6CB7),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color(0xff182848),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      wordSpacing: 2),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "John",
                                  label: Text("Name"),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        color: Color(0xff182848),
                                        offset: Offset(0, 0),
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              margin: EdgeInsets.only(
                                  left: width * 0.13, right: width * 0.13),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _.emailController,
                                validator: (value) => _.emailValidate(value),
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 193, 39, 28),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 193, 39, 28)),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Color(0xff4B6CB7),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color(0xff182848),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      wordSpacing: 2),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "abc123@mail.com",
                                  label: Text("Email"),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        color: Color(0xff182848),
                                        offset: Offset(0, 0),
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              margin: EdgeInsets.only(
                                  left: width * 0.13, right: width * 0.13),
                              child: TextFormField(
                                obscureText: _paaswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _.passwordController,
                                validator: (value) => _.passwordValidate(value),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      _paaswordVisible
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      color: Color(0xff182848),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _paaswordVisible = !_paaswordVisible;
                                      });
                                    },
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 193, 39, 28),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 193, 39, 28)),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xff4B6CB7),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color(0xff182848),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      wordSpacing: 2),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: ".........",
                                  label: Text("Password"),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        color: Color(0xff182848),
                                        offset: Offset(0, 0),
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              margin: EdgeInsets.only(
                                  left: width * 0.13, right: width * 0.13),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _.phoneController,
                                validator: (value) => _.phoneValidate(value),
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 193, 39, 28),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 193, 39, 28)),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Color(0xff4B6CB7),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color(0xff182848),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      wordSpacing: 2),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff182848),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "+92-37474287",
                                  label: Text("Phone"),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.1, right: width * 0.1),
                            width: width,
                            height: height * 0.072,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                    color: Color(0xff4B6CB7),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff4B6CB7),
                                    Color(0xff182848),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topRight,
                                )),
                            child: TextButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  await _.onPressed();

                                  _.clearEmail();
                                  _.clearName();
                                  _.clearPassword();
                                  _.clearPhoneNumber();
                                  // await _.getProfileImage();
                                  Get.to(LoginScreen(),
                                      transition: Transition.leftToRight);
                                }
                              },
                              child: Text(
                                "Signup",
                                style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: height * 0.03,
                            left: width * 0.15,
                            right: width * 0.15),
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already Have Account",
                                style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    color: Color(0xff182848),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Login",
                                  style: TextStyle(
                                      fontFamily: "Ubuntu",
                                      color: Color(0xff4B6CB7),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16)),
                            ),
                          ],
                        ))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
