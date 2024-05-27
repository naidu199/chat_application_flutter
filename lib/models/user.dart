import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String profileUrl;
  final DateTime lastseen;

  UserDetails({
    required this.lastseen,
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'lastseen': lastseen,
        'name': name,
        'profileUrl': profileUrl,
      };

  static UserDetails fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return UserDetails(
      lastseen: (snapshot['lastseen'] as Timestamp).toDate(),
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      name: snapshot['name'],
      profileUrl: snapshot['profileUrl'] ?? "",
    );
  }
}
