// import 'package:chat_application/models/message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FireBaseMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Future<void> addTextMessages(
//       Message message, String senderId, String receiverId) async {
//     try {
//       DocumentReference docref = _firestore
//           .collection('Users')
//           .doc(senderId)
//           .collection('chats')
//           .doc(receiverId);
//     } catch (e) {}
//   }
// }
