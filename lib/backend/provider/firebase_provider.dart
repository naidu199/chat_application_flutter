import 'package:chat_application/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserDetails>? _allUsers;
  UserDetails? _currentUser;
  bool _isLoading = true;

  List<UserDetails> get getUsers => _allUsers!;
  UserDetails get getcurrentUser => _currentUser!;
  bool get isLoading => _isLoading;
  void getAllUsers() {
    try {
      _firestore
          .collection('Users')
          .where('uid', isNotEqualTo: _auth.currentUser!.uid)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        _allUsers =
            users.docs.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    try {
      DocumentSnapshot snap = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .get();
      _currentUser = UserDetails.fromSnapshot(snap);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
