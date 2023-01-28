import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/comment_controller.dart';
import 'package:exd_social_app/models/comments_model.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../db/firebase_auth.dart';
import '../models/user_model.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel postdata;
  CommentsScreen({
    Key? key,
    required this.postdata,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  Future addComments() async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');
    CollectionReference postRef =
        FirebaseFirestore.instance.collection('posts');
    DocumentSnapshot user = await userReference.doc(currentuser!.uid).get();
    UserModel userData =
        UserModel.fromjson(user.data() as Map<String, dynamic>);

    CommentsModel commentData = CommentsModel(
      username: userData.name,
      uid: currentuser!.uid,
      commentText: commentController.text,
      commentImage: controller.commentImageUrl,
      dateTime: DateTime.now().toString(),
      userImage: userData.imageUrl,
      docid: widget.postdata.id,
    );

    await comments
        .add(commentData.toJson())
        .then((value) => "Done")
        .onError((error, stackTrace) => "Error");
  }

  CreateCommentController controller = CreateCommentController();

  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference commentsRefernce =
      FirebaseFirestore.instance.collection('comments');

  User? currentuser = FirebaseAuth.instance.currentUser;

  List<CommentsModel> finalCommentList = [];

  Stream<List<CommentsModel>> getComments() async* {
    QuerySnapshot ref = await commentsRefernce
        .where("postId", isEqualTo: widget.postdata.id)
        .get();
    List<CommentsModel> commentList = [];

    for (int i = 0; i < ref.docs.length; i++) {
      CommentsModel comments = CommentsModel.fromjson(
          ref.docs[i].data() as Map<String, dynamic>, ref.docs[i].id);
      print("before");
      commentList.add(comments);
      print("After");
    }
    finalCommentList = commentList;
    yield commentList;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'All Comments',
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
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xff182848),
                ))
          ],
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: getComments(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            itemCount: finalCommentList.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: ((context, index) {
                              CommentsModel commentdetails =
                                  snapshot.data![index];
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.04,
                                              left: width * 0.04),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xff182848),
                                            child: CircleAvatar(
                                                radius: 14,
                                                backgroundImage: AssetImage(
                                                    "assets/images/person.jpeg")),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.04,
                                                    left: width * 0.02),
                                                child: Text(
                                                  commentdetails.username,
                                                  style: TextStyle(
                                                      fontFamily: "Ubuntu",
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.04,
                                          right: width * 0.04,
                                          top: height * 0.01),
                                      width: width,
                                      child: Text(
                                        commentdetails.commentText,
                                        style: TextStyle(fontFamily: "Ubuntu"),
                                      ),
                                    ),
                                    commentdetails.commentImage.isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.04,
                                                right: width * 0.04,
                                                top: height * 0.001),
                                            width: width,
                                            color: Colors.blue.shade100,
                                            child: Image.network(
                                              commentdetails.commentImage,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )
                                        : SizedBox(),
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: width * 0.04),
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          commentdetails.dateTime,
                                          style:
                                              TextStyle(fontFamily: "Ubuntu"),
                                        ))
                                  ],
                                ),
                              );
                            })),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  }
                  return Container();
                })),
            GetBuilder<CreateCommentController>(
              init: CreateCommentController(),
              initState: (_) {},
              builder: (_) {
                return Column(
                  children: [
                    Divider(
                      indent: 00,
                      endIndent: 00,
                      height: 0,
                      thickness: 1.5,
                      color: Color(0xff4B6CB7),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.04, top: height * 0.006),
                          width: width * 0.7,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: null,
                            controller: commentController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide:
                                      BorderSide(color: Color(0xff182848))),
                              contentPadding: EdgeInsets.only(
                                  top: height * 0.01, left: width * 0.03),
                              constraints:
                                  BoxConstraints(maxHeight: height * 0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(96, 158, 158, 158),
                              hintText: "Add Comment",
                              hintStyle: TextStyle(fontFamily: "Ubuntu"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _.commentImagePickerGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: height * 0.015),
                            child: Icon(
                              Icons.photo_outlined,
                              color: Color(0xff4B6CB7),
                            ),
                          ),
                        ),
                        Container(
                          child: TextButton(
                              onPressed: () {
                                addComments();
                                Get.back();
                              },
                              child: Icon(
                                Icons.send,
                                color: Color(0xff182848),
                              )),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
