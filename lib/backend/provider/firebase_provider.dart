import 'package:chat_application/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserDetails>? _allUsers;
  List<UserDetails>? _allAvaiUsers;
  UserDetails? _currentUser;
  bool _isLoading = true;

  List<UserDetails> get getUsers => _allUsers!;
  List<UserDetails> get getAvailableUsers => _allAvaiUsers!;
  UserDetails get getcurrentUser => _currentUser!;
  bool get isLoading => _isLoading;
  void getAllUsers() {
    try {
      _firestore
          .collection('Users')
          .where('chatIds', arrayContains: _auth.currentUser!.uid)
          .orderBy('lastseen', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        _allUsers =
            users.docs.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        // _isLoading = false;
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
      _isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  void getAllUserAvailable() {
    try {
      _firestore
          .collection('Users')
          .where('uid', isNotEqualTo: _auth.currentUser!.uid)
          .orderBy('lastseen', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        _allAvaiUsers =
            users.docs.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> userSignOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
