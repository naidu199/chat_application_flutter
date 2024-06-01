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

  FirebaseProvider() {
    _initializeData();
  }

  List<UserDetails>? get getUsers => _allUsers;
  List<UserDetails>? get getAvailableUsers => _allAvaiUsers;
  UserDetails? get getCurrentUser => _currentUser;
  bool get isLoading => _isLoading;

  void _initializeData() {
    _isLoading = true;
    notifyListeners();
    // getAllUsers();
    // getUser();
    // getAllUserAvailable();
  }

  void getAllUsers() {
    // print("get all users $_isLoading");
    try {
      _firestore
          .collection('Users')
          .where('chatIds', arrayContains: _auth.currentUser?.uid ?? '')
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
    // print("getuser $isLoading");
    try {
      if (_auth.currentUser != null) {
        // print('get user function');
        DocumentSnapshot snap = await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .get();
        _currentUser = UserDetails.fromSnapshot(snap);
        // print("current user $_currentUser");
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

  void getAllUserAvailable() {
    try {
      _isLoading = true;
      _firestore
          .collection('Users')
          .where('uid', isNotEqualTo: _auth.currentUser?.uid ?? '')
          .orderBy('lastseen', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        _allAvaiUsers =
            users.docs.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        // print("available $_allAvaiUsers");
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

  Future<void> userSignOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
