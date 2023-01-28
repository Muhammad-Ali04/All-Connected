import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:exd_social_app/controller/login_controller.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_background/animated_background.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _paaswordVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: GetBuilder<LoginController>(
          init: LoginController(),
          initState: (_) {},
          builder: (_) {
            return Container(
              child: Form(
                key: _formKey,
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
                    SizedBox(
                      height: height * 0.06,
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
                            left: width * 0.1, right: width * 0.1),
                        child: TextFormField(
                          validator: (value) => _.emailValidate(value),
                          // autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: _.emailController,
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
                                  color: Color.fromARGB(255, 193, 39, 28)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color(0xff4B6CB7),
                            ),
                            labelStyle: TextStyle(
                                fontFamily: "Ubuntu",
                                color: Color(0xff182848),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                wordSpacing: 2),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff182848),
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff182848),
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "abc123@mail.com",
                            label: Text("Email"),
                          ),
                        )),
                    SizedBox(
                      height: height * 0.06,
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
                            left: width * 0.1, right: width * 0.1),
                        child: TextFormField(
                          validator: (value) => _.passwordValidate(value),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _paaswordVisible,
                          controller: _.passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
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
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 193, 39, 28)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 193, 39, 28),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            errorStyle: TextStyle(),
                            prefixIcon: Icon(
                              Icons.lock_open_rounded,
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
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff182848),
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "...........",
                            label: Text("Password"),
                          ),
                        )),
                    SizedBox(
                      height: height * 0.06,
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _.onPressed();

                              _.clearEmail();
                              _.clearPassword();
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: "Ubuntu",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
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
                            Text("New at All Connected ?",
                                style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    color: Color(0xff182848),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            TextButton(
                              onPressed: () {
                                Get.to(SignupScreen(),
                                    transition: Transition.downToUp);
                              },
                              child: Text("Signup",
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
              ),
            );
          },
        ),
      ),
    ));
  }
}
