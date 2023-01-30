import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/profile_controller.dart';
import 'package:exd_social_app/db/firebase_auth.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/chat/rooms.dart';
import 'package:exd_social_app/screens/chat_screen.dart';
import 'package:exd_social_app/screens/comments_screen.dart';
import 'package:exd_social_app/screens/create_post_screen.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/loaction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference postRefernce =
      FirebaseFirestore.instance.collection('posts');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  User? currentuser = FirebaseAuth.instance.currentUser;

  Future<UserModel> getData() async {
    DocumentSnapshot ref = await user.doc(currentuser!.uid).get();
    UserModel userData = UserModel.fromDocumentSnapshot(ref);
    return userData;
  }

  List<PostModel> finalList = [];
  Stream<List<PostModel>> getPosts() async* {
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection('posts')
        .where("uid", isEqualTo: currentuser!.uid)
        .get();
    List<PostModel> postList = [];
    for (var i = 0; i < ref.docs.length; i++) {
      PostModel posts = PostModel.fromjson(
          ref.docs[i].data() as Map<String, dynamic>, ref.docs[i].id);
      print("AAAAAA");
      postList.add(posts);
      print("MMMMMM");
    }
    finalList = postList;
    yield postList;
  }

  ProfileController _controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Color(0xff182848),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        toolbarHeight: height * 0.07,
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xff182848),
          ),
        ),
        actions: [
          Container(
              child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
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
              onTap: () {
                AppSettings.openAppSettings();
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
            InkWell(
              onTap: () {
                Auth.Logout();
              },
              child: Container(
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
            )

            //
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder(
                  future: getData(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(),
                      );
                    } else if (snapshot.hasData) {
                      UserModel profiledata = snapshot.data!;
                      return Stack(children: [
                        _controller.coverPic != null
                            ? Container(
                                child: ShapeOfView(
                                  shape: ArcShape(
                                      direction: ArcDirection.Inside,
                                      position: ArcPosition.Bottom,
                                      height: height * 0.04),
                                  width: width,
                                  height: height * 0.25,
                                  child: Image.file(
                                    _controller.coverPic!,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                child: ShapeOfView(
                                  shape: ArcShape(
                                      direction: ArcDirection.Inside,
                                      position: ArcPosition.Bottom,
                                      height: height * 0.04),
                                  width: width,
                                  height: height * 0.25,
                                  child: Image.asset(
                                    "assets/images/nature.jpeg",
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            _controller.coverPicPickerAndCrop();
                            // await _controller.getCoverPic();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: height * 0.01, left: width * 0.01),
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff4B6CB7).withOpacity(0.3)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xff182848),
                                ),
                                Text(
                                  "Cover Photo",
                                  style: TextStyle(fontFamily: "Ubuntu"),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: height * 0.13),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Color(0xff182848),
                                child: CircleAvatar(
                                  radius: 63,
                                  backgroundImage:
                                      NetworkImage(profiledata.imageUrl),
                                  // AssetImage(
                                  //   "assets/images/person.jpeg",
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]);
                    }
                    return Container();
                  })),
              Container(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getData(),
                        builder: ((Buildcontext, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(),
                            );
                          } else if (snapshot.hasData) {
                            UserModel data = snapshot.data!;

                            return Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.01,
                                  right: width * 0.01,
                                  top: height * 0.02),
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(249, 204, 217, 245),
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                      spreadRadius: 2)
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: height * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data.name,
                                          style: TextStyle(
                                              fontFamily: "Ubuntu",
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: height * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: height * 0.03,
                                            margin: EdgeInsets.only(
                                                left: width * 0.02),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          248, 255, 255, 255),
                                                      blurRadius: 2,
                                                      offset: Offset(2, 1),
                                                      spreadRadius: 1)
                                                ],
                                                color: Color(0xff182848),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.03),
                                                  child: Text(
                                                    "Edit Profile",
                                                    style: TextStyle(
                                                      fontFamily: "Ubuntu",
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  CupertinoIcons.pencil,
                                                  size: 20,
                                                  color: Color(0xff4B6CB7),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                CreatePostScreen(detail: data),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.02),
                                            width: width * 0.33,
                                            height: height * 0.03,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          248, 255, 255, 255),
                                                      blurRadius: 2,
                                                      offset: Offset(2, 1),
                                                      spreadRadius: 1)
                                                ],
                                                color: Color(0xff182848),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.03),
                                                  child: Text(
                                                    "Add Post",
                                                    style: TextStyle(
                                                      fontFamily: "Ubuntu",
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  CupertinoIcons.add,
                                                  size: 14,
                                                  color: Color(0xff4B6CB7),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: height * 0.03, left: width * 0.02),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.mail,
                                            size: 16,
                                            color: Color(0xff182848),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Container(
                                            child: Text(
                                          data.metadata.email,
                                          style: TextStyle(
                                            fontFamily: "Ubuntu",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff4B6CB7),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: height * 0.01, left: width * 0.02),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.phone,
                                            size: 16,
                                            color: Color(0xff182848),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Container(
                                            child: Text(
                                          data.metadata.phoneNumber,
                                          style: TextStyle(
                                            fontFamily: "Ubuntu",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff4B6CB7),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    indent: 0,
                                    endIndent: 0,
                                    thickness: 1,
                                    color: Color(0xff4B6CB7),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.bottomSheet(
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.02,
                                                      right: width * 0.02,
                                                      bottom: height * 0.03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              topRight: Radius
                                                                  .circular(12),
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      12)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xff182848),
                                                            blurStyle:
                                                                BlurStyle.solid,
                                                            blurRadius: 1,
                                                            offset:
                                                                Offset(0, 0),
                                                            spreadRadius: 1)
                                                      ]),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.03),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              data.name,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Ubuntu",
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Container(
                                                              child: Icon(
                                                                Icons
                                                                    .male_rounded,
                                                                size: 22,
                                                                color: Color(
                                                                    0xff4B6CB7),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01,
                                                            top: height * 0.03),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Icon(
                                                                Icons.mail,
                                                                size: 16,
                                                                color: Color(
                                                                    0xff182848),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.02,
                                                            ),
                                                            Container(
                                                                child: Text(
                                                              data.metadata
                                                                  .email,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Ubuntu",
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xff4B6CB7),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01,
                                                            top: height * 0.03),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Icon(
                                                                Icons.phone,
                                                                size: 16,
                                                                color: Color(
                                                                    0xff182848),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.02,
                                                            ),
                                                            Container(
                                                                child: Text(
                                                              data.metadata
                                                                  .phoneNumber,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Ubuntu",
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xff4B6CB7),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01,
                                                            top: height * 0.03),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Icon(
                                                                Icons
                                                                    .location_on,
                                                                size: 16,
                                                                color: Color(
                                                                    0xff182848),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.02,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.01,
                                                            top: height * 0.03),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                child: Text(
                                                              "Bio:",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Ubuntu",
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff182848),
                                                              ),
                                                            )),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.02,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              isDismissible: true,
                                              enableDrag: true,
                                              barrierColor: Color.fromARGB(
                                                  108, 158, 158, 158));
                                        },
                                        child: Container(
                                          child: Text(
                                            "More Info",
                                            style: TextStyle(
                                                fontFamily: "Ubuntu",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    indent: 0,
                                    endIndent: 0,
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error");
                          }
                          return Container();
                        })),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    StreamBuilder(
                        stream: getPosts(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: finalList.length,
                                itemBuilder: (context, index) {
                                  PostModel userPosts = snapshot.data![index];
                                  return SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          width * 0.01,
                                          height * 0.01,
                                          width * 0.01,
                                          height * 0.02),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                                left: width * 0.04,
                                                top: height * 0.01),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 21,
                                                  backgroundColor:
                                                      Color(0xff182848),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(userPosts
                                                            .userImage),
                                                    // AssetImage(
                                                    //     "assets/images/person.jpeg"),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: width * 0.02),
                                                      child: Text(
                                                        userPosts.username,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Ubuntu",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff182848)),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: width * 0.02),
                                                      child: Text(
                                                        userPosts.dateTime,
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
                                                userPosts.postText,
                                                style: TextStyle(
                                                    fontFamily: "Ubuntu",
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          userPosts.postImage.isNotEmpty
                                              ? Container(
                                                  width: width,
                                                  child: Image.network(
                                                    userPosts.postImage,
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
                                                    child: Icon(
                                                      Icons
                                                          .thumb_up_alt_rounded,
                                                      size: 18,
                                                      color: Color(0xff4B6CB7),
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
                                                      Text(
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
                                            padding: const EdgeInsets.all(10.0),
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
                                                        color:
                                                            Color(0xff182848)),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        CommentsScreen(
                                                          postdata: userPosts,
                                                        ),
                                                        transition: Transition
                                                            .downToUp);
                                                  },
                                                  child: Container(
                                                    width: width * 0.3,
                                                    child: Icon(
                                                        Icons.comment_rounded,
                                                        color:
                                                            Color(0xff182848)),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    width: width * 0.3,
                                                    child: Icon(
                                                        Icons.ios_share_rounded,
                                                        color:
                                                            Color(0xff182848)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error");
                          }
                          return Container();
                        }))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
