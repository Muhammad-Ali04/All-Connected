import 'package:exd_social_app/models/post_model.dart';

class CommentsModel {
  late final String docid;
  late final String commentText;
  late final String uid;

  late final String userImage;
  late final String commentImage;
  late final String dateTime;
  late final String username;

  CommentsModel({
    required this.username,
    required this.userImage,
    required this.dateTime,
    required this.commentText,
    required this.commentImage,
    required this.docid,
    required this.uid,
  });

  CommentsModel.withoutId({
    // required this.postId,
    required this.docid,
    required this.username,
    required this.uid,
    required this.commentText,
    required this.userImage,
    required this.commentImage,
    required this.dateTime,
  });
  CommentsModel.fromjson(Map<String, dynamic> data, String id) {
    username = data['name'] ?? "";
    commentText = data['commentText'] ?? "";
    commentImage = data['commentImage'] ?? "";
    dateTime = data['dateTime'] ?? DateTime.now().toString();
    userImage = data['ProfileImageUrl'] ?? "";
    uid = data['uid'] ?? "";
    docid = id;
    // postId = data['postId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = username;
    data['commentText'] = commentText;
    data['commentImage'] = commentImage;
    data['dateTime'] = dateTime;
    data['uid'] = uid;
    data['ProfileImageUrl'] = userImage;
    data["postId"] = docid;
    // data['postId'] = postId;

    return data;
  }
}
