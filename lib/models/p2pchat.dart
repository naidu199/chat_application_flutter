import 'package:chat_application/models/message.dart';

class Chat {
  final String chatId;
  final List<String> participants;
  final List<Message> messages;

  Chat({
    required this.chatId,
    required this.participants,
    required this.messages,
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      participants: List<String>.from(json['participants']),
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'participants': participants,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
