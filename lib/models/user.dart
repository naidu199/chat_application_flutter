import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String username;
  final String email;
  final String profileUrl;
  final DateTime lastseen;

  UserDetails({
    required this.lastseen,
    required this.uid,
    required this.username,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'lastseen': lastseen,
        'profileUrl': profileUrl,
      };

  static UserDetails fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return UserDetails(
      lastseen: snapshot['lastseen'] ?? "",
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      profileUrl: snapshot['profileImage'] ?? "",
    );
  }
}
