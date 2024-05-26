import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String username;
  final String email;
  final String profileUrl;
  final String bio;

  UserDetails({
    required this.bio,
    required this.uid,
    required this.username,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': '',
        'profileUrl': profileUrl,
      };

  static UserDetails fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return UserDetails(
      bio: snapshot['bio'] ?? "",
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      profileUrl: snapshot['profileImage'] ?? "",
    );
  }
}
