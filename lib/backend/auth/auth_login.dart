import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthLogin {
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error has occured";
    User? user;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
        user = cred.user;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .update({
          'lastseen': DateTime.now(),
        });
      } else {
        res = "please enter all the fields ";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid Password ';
      } else if (e.message.toString() ==
          "The supplied auth credential is incorrect, malformed or has expired.") {
        res = "Invalid credential";
      } else {
        res = e.message.toString();
        // print(res);
      }
    } catch (e) {
      res = e.toString();
    }
    // print(res);
    return res;
  }
}
