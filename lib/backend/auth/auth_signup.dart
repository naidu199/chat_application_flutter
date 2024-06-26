import 'dart:typed_data';

import 'package:chat_application/backend/storage_methods.dart';
import 'package:chat_application/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSignUp {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserDetails> getUserDetails() async {
    User currentuser = auth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('Users').doc(currentuser.uid).get();
    // print(snap.data());
    return UserDetails.fromSnapshot(snap);
  }

  Future<String> signup({
    required String email,
    required String password,
    required String username,
    required String name,
    Uint8List? profilepic,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        //user signup
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // print('1');
        String profileUrl;
        if (profilepic != null) {
          profileUrl = await StorageMethods()
              .uploadImageToStorage(childName: 'profilepic', file: profilepic);
        } else {
          profileUrl =
              "https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg";
        }

        //adding user to database

        // print('2');
        UserDetails userDetails = UserDetails(
          name: name,
          lastseen: DateTime.now(),
          uid: cred.user!.uid,
          username: username,
          email: email,
          chatIds: [],
          profileUrl: profileUrl,
        );
        await firestore
            .collection('Users')
            .doc(cred.user!.uid)
            .set(userDetails.toJson());
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == "invalid-email") {
        res = "Email is Badly Formated";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
      // print(e.toString());
    }
    return res;
  }
}
