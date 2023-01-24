// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exd_social_app/models/user_model.dart';
// import 'package:exd_social_app/screens/user_chat_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:styled_divider/styled_divider.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// import 'chat_ui_screen.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   CollectionReference userRef = FirebaseFirestore.instance.collection('user');

//   User? currentuser = FirebaseAuth.instance.currentUser;

//   List<UserModel> finalList = [];
//   Stream<List<UserModel>> getUsers() async* {
//     QuerySnapshot ref =
//         await userRef.where("uid", isNotEqualTo: currentuser!.uid).get();
//     List<UserModel> userList = [];
//     for (var i = 0; i < ref.docs.length; i++) {
//       UserModel users =
//           UserModel.fromjson(ref.docs[i].data() as Map<String, dynamic>);
//       print("AAAAAA");
//       userList.add(users);
//       print("/$userList");
//     }
//     finalList = userList;
//     yield userList;
//   }

//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         shadowColor: Color(0xff182848),
//         systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: Color(0xff182848),
//             statusBarIconBrightness: Brightness.light),
//         toolbarHeight: height * 0.07,
//         elevation: 1,
//         backgroundColor: Color(0xff182848),
//         title: Text(
//           'Chats',
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               foreground: Paint()
//                 ..shader = LinearGradient(colors: <Color>[
//                   Color.fromARGB(255, 178, 190, 218),
//                   Colors.white,
//                 ]).createShader(Rect.fromLTWH(30.0, 30.0, 100.0, 100.0))),
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: Color.fromARGB(255, 178, 190, 218),
//             )),
//       ),
//       body: Container(
//         child: StreamBuilder(
//             stream: getUsers(),
//             builder: ((context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasData) {
//                 return ListView.builder(
//                     itemCount: finalList.length,
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemBuilder: ((context, index) {
//                       UserModel userData = snapshot.data![index];
//                       return InkWell(
//                         splashFactory: InkRipple.splashFactory,
//                         splashColor: Color.fromARGB(21, 178, 190, 218),
//                         onTap: () async {
//                           User? currentUser = FirebaseAuth.instance.currentUser;
//                           DocumentSnapshot user =
//                               await userRef.doc(currentUser!.uid).get();
//                           UserModel data = UserModel.fromjson(
//                               user.data() as Map<String, dynamic>);
//                           var current_user = types.User(
//                             id: data.userId,
//                             firstName: data.name,
//                             imageUrl: "",
//                           );

//                           var receiver_user = types.User(
//                             id: userData.userId,
//                             firstName: userData.name,
//                             imageUrl: "",
//                           );

//                           Get.to(
//                               UserChatScreen(
//                                 receiverUser: receiver_user,
//                                 user: current_user,
//                               ),
//                               transition: Transition.size);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: height * 0.02),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.only(left: width * 0.04),
//                                     height: height * 0.054,
//                                     width: width * 0.12,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: Color(0xff4B6CB7),
//                                           style: BorderStyle.solid,
//                                         ),
//                                         borderRadius: BorderRadius.circular(80),
//                                         color: Color(0xff4B6CB7)),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(80),
//                                       child: Image.asset(
//                                         "assets/images/person.jpeg",
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(left: width * 0.02),
//                                     child: Text(
//                                       userData.name,
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           color: Color(0xff4B6CB7),
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Expanded(child: Center()),
//                                   Container(
//                                     child: IconButton(
//                                         onPressed: () {},
//                                         icon: Icon(
//                                           Icons.more_horiz_rounded,
//                                           size: 16,
//                                         )),
//                                   )
//                                 ],
//                               ),
//                               StyledDivider(
//                                 color: Color(0xff4B6CB7),
//                                 endIndent: 0,
//                                 indent: 0,
//                                 thickness: 0.2,
//                                 lineStyle: DividerLineStyle.dotted,
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     }));
//               } else if (snapshot.hasError) {
//                 return Text("Error");
//               }
//               return Container();
//             })),
//       ),
//     );
//   }
// }
