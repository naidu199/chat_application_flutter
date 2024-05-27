import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String content;
  final MessageType messageType;
  final Timestamp sentAt;

  Message(
      {required this.senderId,
      required this.content,
      required this.messageType,
      required this.sentAt});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'messageType': messageType.name,
      'sentAt': sentAt,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      messageType: MessageType.values.byName(json['messageType']),
      sentAt: json['sentAt'] as Timestamp,
    );
  }
}

enum MessageType { text, image }
