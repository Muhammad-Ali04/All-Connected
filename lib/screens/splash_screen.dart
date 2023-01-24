import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:exd_social_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedSplashScreen(
      nextScreen: LoginScreen(),
      splash: Stack(
        children: [
          Container(
            height: height,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    // width: width * 0.3,
                    height: height * 0.3,
                    child: Image.asset(
                      "assets/images/splash.png",
                      fit: BoxFit.fill,
                    )),
              ],
            ),
          )
        ],
      ),
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: Duration(seconds: 3),
      // backgroundColor: Color.fromARGB(255, 203, 194, 177),
      pageTransitionType: PageTransitionType.leftToRight,
      splashIconSize: height,
      duration: 2000,
    );
  }
}
