import 'dart:typed_data';

import 'package:chat_application/backend/storage_methods.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/p2pchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String generateChatId(String senderId, String receiverId) {
    List uids = [senderId, receiverId];
    uids.sort();
    String chatId = uids[0] + uids[1];
    return chatId;
  }

  Future<bool> checkChatExist(String senderId, String receiverId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('chats')
        .where('chatId', isEqualTo: generateChatId(senderId, receiverId))
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> createNewChat(String senderId, String receiverId) async {
    String chatId = generateChatId(senderId, receiverId);
    try {
      Chat chat = Chat(
        chatId: chatId,
        participants: [senderId, receiverId],
        messages: [],
      );
      await _firestore.collection('chats').doc(chatId).set(chat.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addChatMessages(
      Message message, String senderId, String receiverId) async {
    String chatId = generateChatId(senderId, receiverId);
    try {
      DocumentReference docref = _firestore.collection('chats').doc(chatId);
      await docref.update(
        {
          'messages': FieldValue.arrayUnion([message.toJson()])
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> mediaUrl(
      String senderId, String receiverId, Uint8List file) async {
    String chatId = generateChatId(senderId, receiverId);
    String imageUrl = '';
    try {
      String url = await StorageMethods()
          .uploadImageToStorage(childName: 'media', file: file, chatId: chatId);

      imageUrl = url;
    } catch (e) {
      print(e.toString());
    }
    return imageUrl;
  }

  Stream<DocumentSnapshot<Chat>> getUserChat(
      String senderId, String receiverId) {
    String chatId = generateChatId(senderId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .withConverter<Chat>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data != null) {
              return Chat.fromJson(data);
            } else {
              throw Exception("Document data is null");
            }
          },
          toFirestore: (chat, _) => chat.toJson(),
        )
        .snapshots();
  }
}
