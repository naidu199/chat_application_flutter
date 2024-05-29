import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String profileUrl;
  final DateTime lastseen;
  final List chatIds;

  UserDetails({
    required this.lastseen,
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.chatIds,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'lastseen': Timestamp.fromDate(lastseen),
        'name': name,
        'chatIds': chatIds,
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
      chatIds: List<String>.from(snapshot['chatIds']),
      profileUrl: snapshot['profileUrl'] ?? "",
    );
  }
}
