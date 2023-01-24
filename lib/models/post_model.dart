import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  // CollectionReference post = FirebaseFirestore.instance.collection("posts");
  late String id;
  late final String postText;
  late final String uid;
  late final String userImage;
  late final String postImage;
  late final String dateTime;
  late final int likesCount;
  late final int commentsCount;
  late final String username;
  // default constructor
  PostModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.postText,
    required this.userImage,
    required this.postImage,
    required this.dateTime,
    required this.likesCount,
    required this.commentsCount,
  });

  // for post creation
  PostModel.withoutId({
    required this.username,
    required this.uid,
    required this.postText,
    required this.userImage,
    required this.postImage,
    required this.dateTime,
  });
  // when we read data from firebase this will be used for converting DocumentSnapshot to model object
  PostModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    uid = documentSnapshot['uid'] ?? "";
    postText = documentSnapshot["postText"] ?? "";
    postImage = documentSnapshot["postImage"] ?? "";
    userImage = documentSnapshot["ProfileImageUrl"] ?? " ";
    username = documentSnapshot["name"] ?? "";
    // likesCount = documentSnapshot["likesCount"] ?? 0;
    // commentsCount = documentSnapshot["commentsCount"] ?? 0;
    dateTime = documentSnapshot["dateTime"] ?? DateTime.now().isUtc.toString();
  }
  PostModel.fromjson(Map<String, dynamic> data, String id) {
    username = data['name'] ?? "";
    uid = data['uid'] ?? "";
    id = id;
    postText = data["postText"] ?? "";
    postImage = data["postImage"] ?? "";
    userImage = data["ProfileImageUrl"] ?? "";
    // likesCount = data["likesCount"] ?? 0;
    // commentsCount = data["commentsCount"] ?? 0;
    dateTime = data["dateTime"] ?? DateTime.now().toString();
  }

  // this will be used to convert PostModelNew.withoutId to Map<String,dynamic>
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = username;
    data['uid'] = uid;

    data['postText'] = postText;
    data['postImage'] = postImage;
    data['ProfileImageUrl'] = userImage;
    data['dateTime'] = dateTime;
    // data["postId"] = id;
    return data;
  }
}
