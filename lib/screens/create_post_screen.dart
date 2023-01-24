import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/create_post_controller.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:get/get.dart';

class CreatePostScreen extends StatefulWidget {
  final UserModel detail;
  CreatePostScreen({
    Key? key,
    required this.detail,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with TickerProviderStateMixin {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  User? currentuser = FirebaseAuth.instance.currentUser;

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 260));
    final curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInExpo);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<CreatePostController>(
      init: CreatePostController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionBubble(
              animation: _animation,
              iconData: Icons.camera,
              backGroundColor: Color(0xff182848),
              iconColor: Colors.white,
              items: <Bubble>[
                Bubble(
                    icon: (Icons.camera_alt_rounded),
                    iconColor: Colors.white,
                    title: "Camera",
                    titleStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: "Ubuntu"),
                    bubbleColor: Color(0xff4B6CB7),
                    onPress: () {
                      _.PostImagePickerCamera();
                    }),
                Bubble(
                    icon: (Icons.photo_library_sharp),
                    iconColor: Colors.white,
                    title: "Gallery",
                    titleStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: "Ubuntu"),
                    bubbleColor: Color(0xff4B6CB7),
                    onPress: () {
                      _.PostImagePickerGallery();
                    }),
              ],
              onPress: () {
                _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward();
              },
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(
                  "Create Post",
                  style:
                      TextStyle(color: Color(0xff4B6CB7), fontFamily: "Ubuntu"),
                ),
                elevation: 0.5,
                shadowColor: Color(0xff182848),
                backgroundColor: Colors.white,
                actions: [
                  InkWell(
                    onTap: () {
                      _.adddPost();
                      Get.back();
                    },
                    splashColor: Colors.transparent,
                    child: Container(
                        width: width * 0.15,
                        margin: EdgeInsets.only(right: width * 0.05),
                        alignment: Alignment.center,
                        child: Text(
                          "Post",
                          style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              color: Color(0xff182848),
                              fontSize: 16),
                        )),
                  )
                ],
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xff182848),
                  ),
                )),
            body: SafeArea(
              child: GetBuilder<CreatePostController>(
                init: CreatePostController(),
                initState: (_) {},
                builder: (_) {
                  return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.03, top: height * 0.02),
                                child: CircleAvatar(
                                  radius: 21,
                                  backgroundColor: Color(0xff182848),
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        "assets/images/person.jpeg",
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.02),
                                child: Text(
                                  widget.detail.name,
                                  style: TextStyle(
                                      fontFamily: "Ubuntu",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff182848)),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                top: height * 0.04),
                            width: width,
                            child: TextFormField(
                              controller: _.textpost,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              cursorHeight: 25,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: "What's going on?",
                                  hintStyle: TextStyle(
                                    fontFamily: "Ubuntu",
                                    fontSize: 20,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                          _.postimage != null
                              ? Container(
                                  margin: EdgeInsets.only(top: height * 0.04),
                                  width: width,
                                  child: Image.file(
                                    _.postimage!,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: height * 0.04),
                                  width: width,
                                  child: Container()),
                        ]),
                  );
                },
              ),
            ));
        ;
      },
    );
  }
}
