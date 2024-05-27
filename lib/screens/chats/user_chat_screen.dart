import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserChatScreen extends StatefulWidget {
  final UserDetails userDetails;
  final UserDetails currentUser;
  const UserChatScreen(
      {super.key, required this.userDetails, required this.currentUser});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  ChatUser? currentChatUser, otherChatUser;

  @override
  void initState() {
    super.initState();
    currentChatUser = ChatUser(
      id: widget.currentUser.uid,
      firstName: widget.currentUser.name,
      profileImage: widget.currentUser.profileUrl,
    );
    otherChatUser = ChatUser(
      id: widget.userDetails.uid,
      firstName: widget.userDetails.name,
      profileImage: widget.userDetails.profileUrl,
    );
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    Message message = Message(
      senderId: widget.currentUser.uid,
      content: chatMessage.text,
      messageType: MessageType.text,
      sentAt: Timestamp.fromDate(
        chatMessage.createdAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: _userAppBar(),
        body: _userChatBody());
  }

  DashChat _userChatBody() {
    return DashChat(
      messageOptions: const MessageOptions(
        showOtherUsersAvatar: true,
        showTime: true,
      ),
      inputOptions: InputOptions(alwaysShowSend: true),
      currentUser: currentChatUser!,
      onSend: (ChatMessage message) {},
      messages: [],
    );
  }

  AppBar _userAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      foregroundColor: primaryColor,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userDetails.profileUrl),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userDetails.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: primaryColor),
              ),
              Text(
                "last seen ${timeago.format(widget.userDetails.lastseen)}",
                style: const TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
    );
  }
}
