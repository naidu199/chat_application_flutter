import 'package:chat_application/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserDetails>? _allUsers;
  List<UserDetails> get getUsers => _allUsers!;
  void getAllUsers() {
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        _allUsers =
            users.docs.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        notifyListeners();
      });
    } catch (e) {}
  }
}
