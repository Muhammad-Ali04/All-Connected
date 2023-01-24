import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/signup_controller.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/chat/rooms.dart';
import 'package:exd_social_app/screens/chat_screen.dart';
import 'package:exd_social_app/screens/comments_screen.dart';
import 'package:exd_social_app/screens/create_post_screen.dart';
import 'package:exd_social_app/screens/loaction_screen.dart';
import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  User? currentuser = FirebaseAuth.instance.currentUser;
  List<PostModel> finalList = [];
  CollectionReference postRefernce =
      FirebaseFirestore.instance.collection('posts');

  @override
  @override
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  Stream<List<PostModel>> getPosts() async* {
    QuerySnapshot ref = await postRefernce.get();
    List<PostModel> postList = [];
    for (var i = 0; i < ref.docs.length; i++) {
      PostModel posts = PostModel.fromDocumentSnapshot(ref.docs[i]);
      print("AAAAAA");
      postList.add(posts);
      print("/$postList");
    }
    finalList = postList;
    yield postList;
  }

  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Color(0xff182848), width: 1)),
        automaticallyImplyLeading: false,
        shadowColor: Color(0xff182848),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        toolbarHeight: height * 0.07,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'All Connected',
          style: TextStyle(
              fontFamily: "Ubuntu",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(colors: <Color>[
                  Color(0xff4B6CB7),
                  Color(0xff182848),
                ]).createShader(Rect.fromLTWH(30.0, 30.0, 100.0, 100.0))),
        ),
        actions: [
          Container(
              child: IconButton(
            onPressed: () {
              if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              } else {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: Icon(
              Icons.menu,
              size: 25,
              color: Color(0xff182848),
            ),
          ))
        ],
      ),
      endDrawer: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff4B6CB7),
                  blurRadius: 2,
                  offset: Offset(1, 3),
                  spreadRadius: 4)
            ]),
        child: Drawer(
          // width: width * 0.65,
          backgroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          ),
          child:
              ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
            FutureBuilder(
                future: user.doc(currentuser!.uid).get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    UserModel userdata = UserModel.fromjson(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return Container(
                      child: ListTile(
                          leading: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                cursor: '.',
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
                                        Color(0xff182848),
                                      ]).createShader(Rect.fromLTWH(
                                          30.0, 30.0, 100.0, 100.0))),
                              ),
                            ],
                          ),
                          trailing: Container(
                            height: height * 0.084,
                            width: width * 0.16,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4B6CB7),
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.amberAccent),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.network(
                                userdata.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("error"),
                    );
                  }
                  return Container();
                })),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
                Get.to(HomeScreen());
              },
              child: Container(
                width: width,
                // height: height * 0.04,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),

                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.home_filled,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "Home",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
                Get.to(ProfileScreen(), transition: Transition.rightToLeft);
              },
              child: Container(
                width: width,
                // height: height * 0.04,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),

                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.person,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "Dashboard",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
                Get.to(RoomsPage(), transition: Transition.fade);
              },
              child: Container(
                width: width,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.message_rounded,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "Chat",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
                Get.to(LoactionScreen(), transition: Transition.rightToLeft);
              },
              child: Container(
                width: width,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "Live Location",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {},
              child: Container(
                width: width,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.settings,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white,
              onTap: () {},
              child: Container(
                width: width,
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    top: height * 0.04),
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Icon(
                    Icons.info,
                    color: Color(0xff4B6CB7),
                    size: 25,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Color(0xff4B6CB7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.13,
            ),
            Container(
              width: width,
              height: height * 0.04,
              margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurStyle: BlurStyle.outer,
                      color: Colors.blue,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                      spreadRadius: 2)
                ],
                color: Color(0xff4B6CB7),
              ),
              child: InkWell(
                onTap: () {
                  Auth.Logout();
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/turn-off.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        "SignOut",
                        style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff182848),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )

            //
          ]),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: user.doc(currentuser!.uid).get(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel userdata = UserModel.fromjson(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return Container(
                      width: width,
                      height: height * 0.08,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(ProfileScreen(),
                                  transition: Transition.rightToLeft);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.03),
                              child: CircleAvatar(
                                radius: 21,
                                backgroundColor: Color(0xff182848),
                                child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(userdata.imageUrl)
                                    // AssetImage("assets/images/person.jpeg"),
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              showCursor: false,
                              onTap: () {
                                Get.to(
                                    CreatePostScreen(
                                      detail: userdata,
                                    ),
                                    transition: Transition.downToUp);
                              },
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xff4B6CB7),
                                        strokeAlign: StrokeAlign.center)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xff4B6CB7),
                                        strokeAlign: StrokeAlign.center)),
                                constraints: BoxConstraints(
                                  maxHeight: height * 0.042,
                                  maxWidth: width * 0.64,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: width * 0.05),
                                hintText: "Post Your Stories",
                                hintStyle: TextStyle(
                                    fontFamily: "Ubuntu",
                                    color: Color(0xff182848),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.photo_library_outlined,
                                  color: Color(0xff182848),
                                )),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                })),
            Container(
              width: width,
              height: height * 0.0015,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[Color(0xff182848), Color(0xff4B6CB7)],
                end: Alignment.center,
                begin: Alignment.centerLeft,
              )),
            ),
            StreamBuilder(
                stream: getPosts(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: finalList.length,
                                    itemBuilder: (Buildcontext, index) {
                                      PostModel postData =
                                          snapshot.data![index];
                                      return Container(
                                        margin: EdgeInsets.fromLTRB(
                                            width * 0.01,
                                            height * 0.01,
                                            width * 0.01,
                                            height * 0.02),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    249, 204, 217, 245),
                                                blurRadius: 4,
                                                offset: Offset(0, 3),
                                                spreadRadius: 2)
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.01,
                                                  top: height * 0.01),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: CircleAvatar(
                                                      radius: 21,
                                                      backgroundColor:
                                                          Color(0xff182848),
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                postData
                                                                    .userImage)
                                                        // AssetImage(
                                                        //     "assets/images/person.jpeg"),
                                                        ,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.02),
                                                        child: Text(
                                                          postData.username,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Ubuntu",
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff182848)),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.02),
                                                        child: Text(
                                                          postData.dateTime,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Ubuntu",
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xff4B6CB7)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Expanded(child: Center()),
                                                  Container(
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons
                                                              .more_horiz_rounded,
                                                          color:
                                                              Color(0xff182848),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.05,
                                                  top: height * 0.02,
                                                  bottom: height * 0.01),
                                              child: Container(
                                                child: Text(
                                                  postData.postText,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            postData.postImage.isNotEmpty
                                                ? Container(
                                                    width: width,
                                                    child: Image.network(
                                                      postData.postImage,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Padding(
                                              padding:
                                                  EdgeInsets.all(width * 0.02),
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: width * 0.04),
                                                      child: Icon(
                                                        Icons
                                                            .thumb_up_alt_rounded,
                                                        size: 18,
                                                        color:
                                                            Color(0xff4B6CB7),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.01,
                                                    ),
                                                    Text(
                                                      "4k",
                                                      style: TextStyle(
                                                          fontFamily: "Ubuntu",
                                                          color:
                                                              Color(0xff182848),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Expanded(child: Center()),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "10k Comments",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Ubuntu",
                                                              color: Color(
                                                                  0xff182848),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .lens_blur_outlined,
                                                          size: 10,
                                                          color:
                                                              Color(0xff4B6CB7),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.02),
                                                          child: Text(
                                                            "10k Shares",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Ubuntu",
                                                                color: Color(
                                                                    0xff182848),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              indent: 10,
                                              endIndent: 10,
                                              height: 0,
                                              thickness: 1,
                                              color: Color(0xff4B6CB7),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: width * 0.3,
                                                      child: Icon(
                                                          Icons
                                                              .thumb_up_alt_outlined,
                                                          color: Color(
                                                              0xff182848)),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          CommentsScreen(
                                                            postdata: postData,
                                                          ),
                                                          transition: Transition
                                                              .downToUp);
                                                    },
                                                    child: Container(
                                                      width: width * 0.3,
                                                      child: Icon(
                                                          Icons.comment_rounded,
                                                          color: Color(
                                                              0xff182848)),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: width * 0.3,
                                                      child: Icon(
                                                          Icons
                                                              .ios_share_rounded,
                                                          color: Color(
                                                              0xff182848)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }))));
                  } else if (snapshot.hasError) {
                    return Container(
                      child: Text("data not"),
                    );
                  }
                  return Container();
                }))
          ],
        ),
      ),
    );
  }
}
