import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // late final String coverPic;

  UserModel({
    required this.name,
    required this.metadata,
    // required this.userId,
    required this.imageUrl,
    // required this.coverPic
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot["firstName"] ?? " ";
    metadata = metaData.fromjson(documentSnapshot['metadata']);
    // email = documentSnapshot['email'] ?? " ";
    // phoneNumber = documentSnapshot['phone'] ?? " ";
    imageUrl = documentSnapshot['imageUrl'] ?? " ";
    // coverPic = documentSnapshot['coverPic'] ?? "";
  }

  UserModel.fromjson(
    Map<String, dynamic> data,
  ) {
    name = data['firstName'] ?? "";
    metadata = metaData.fromjson(data['metadata']);
    // email = data['email'] ?? "";
    // userId = data["uid"] ?? "";
    // phoneNumber = data['phone'] ?? "";
    imageUrl = data['imageUrl'] ?? "";
    // coverPic = data['coverPic'] ?? "";
  }

  late final String name;
  late final String imageUrl;
  late metaData metadata;
  // late final String password;

  // late final String userId;

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, Object>();
    data['firstName'] = this.name;
    // data['email'] = this.email;
    // data['phone'] = this.phoneNumber;
    data['imageUrl'] = this.imageUrl;
    data['metadata'] = this.metadata.tojson();
    // data['coverPic'] = this.coverPic;
    return data;
  }
}

class metaData {
  late final String email;
  late final String phoneNumber;
  // late final String coverPic;
  metaData({
    required this.email,
    required this.phoneNumber,
  });

  metaData.fromjson(
    Map<String, dynamic> data,
  ) {
    email = data['email'] ?? "";

    phoneNumber = data['phone'] ?? "";
    // coverPic = data['coverPic'] ?? "";
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, Object>();
    data['email'] = this.email;
    data['phone'] = this.phoneNumber;
    // data['coverPic'] = this.coverPic;
    return data;
  }

  metaData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    email = documentSnapshot['email'];
    phoneNumber = documentSnapshot['phone'];
    // coverPic = documentSnapshot['coverPic'];
  }
}
