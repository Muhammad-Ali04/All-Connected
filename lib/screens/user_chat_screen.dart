// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exd_social_app/models/chat_model.dart';
// import 'package:exd_social_app/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// class UserChatScreen extends StatefulWidget {
//   final UserModel userDetail;
//   UserChatScreen({Key? key, required this.userDetail}) : super(key: key);

//   @override
//   State<UserChatScreen> createState() => _UserChatScreenState();
// }

// class _UserChatScreenState extends State<UserChatScreen> {
//   List<types.Message> _meassagesList = [];
//   late types.User _user;

//   loadCurrentUser() {
//     User? fbCurrentUser = FirebaseAuth.instance.currentUser;
//     _user = types.User(
//       id: fbCurrentUser?.uid ?? "na",
//       firstName: fbCurrentUser!.displayName ?? "",
//       imageUrl: "",
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadCurrentUser();
//   }

//   // CollectionReference chatRefernce =
//   //     FirebaseFirestore.instance.collection('chats');
//   // CollectionReference userRef = FirebaseFirestore.instance.collection('user');
//   //
//   // sendMeassages() async {
//   //   DocumentSnapshot userdoc = await userRef.doc(user!.uid).get();
//   //   UserModel userData =
//   //       UserModel.fromjson(userdoc.data() as Map<String, dynamic>);

//   //   ChatModel chatData = ChatModel(
//   //       chatText: messageController.text,
//   //       dateTime: DateTime.now().toString(),
//   //       imageUrl: '',
//   //       status: 1,
//   //       senderUser: ChatUser(
//   //           email: userData.email,
//   //           uid: userData.userId,
//   //           name: userData.name,
//   //           userImageUrl: userData.profilePic),
//   //       receiverUser: ChatUser(
//   //           email: widget.userDetail.email,
//   //           uid: widget.userDetail.userId,
//   //           name: widget.userDetail.name,
//   //           userImageUrl: widget.userDetail.profilePic));

//   //   await chatRefernce
//   //       .add(chatData.toJson())
//   //       .then((value) => print("sucees"))
//   //       .onError((error, stackTrace) => print("error"));
//   // }

//   final messageController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         appBar: AppBar(
//           titleSpacing: 2,
//           backgroundColor: Color(0xff182848),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: Color(0xff4B6CB7),
//               ),
//               SizedBox(
//                 width: width * 0.03,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: width * 0.01),
//                 child: CircleAvatar(
//                   radius: 17,
//                   backgroundImage: AssetImage("assets/images/person.jpeg"),
//                 ),
//               ),
//               SizedBox(
//                 width: width * 0.03,
//               ),
//               Text(widget.userDetail.name),
//             ],
//           ),
//           automaticallyImplyLeading: false,
//           actions: [
//             Container(
//                 child: IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.video_call_rounded),
//             )),
//             Container(
//                 child: IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.call),
//             )),
//           ],
//         ),
//         body: Container(
//           child: Chat(
//             messages: _meassagesList,
//             // onAttachmentPressed: _handleAttachmentPressed,
//             // onMessageTap: _handleMessageTap,
//             // onPreviewDataFetched: _handlePreviewDataFetched,
//             // onSendPressed: _handleSendPressed,
//             showUserAvatars: true,
//             showUserNames: true,
//             user: _user, onSendPressed: (PartialText) {},
//           ),
//         )

//         // Container(
//         //   child: Column(
//         //     children: [
//         //       Expanded(child: Center()),
//         //       Container(
//         //         child: Row(
//         //           children: [
//         //             TextFormField(
//         //               controller: messageController,
//         //               decoration: InputDecoration(
//         //                   constraints: BoxConstraints(
//         //                       maxHeight: height * 0.1, maxWidth: width * 0.3),
//         //                   suffixIcon: IconButton(
//         //                       onPressed: () {
//         //                         sendMeassages();
//         //                       },
//         //                       icon: Icon(Icons.ios_share_rounded))),
//         //             )
//         //           ],
//         //         ),
//         //       )
//         //     ],
//         //   ),
//         // ),
//         );
//   }
// }
