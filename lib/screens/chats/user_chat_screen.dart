import 'dart:typed_data';

import 'package:chat_application/backend/firebase_methods.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/p2pchat.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:chat_application/utils/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

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
  Uint8List? pickedImage;
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
    Message? message;
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        message = Message(
          senderId: currentChatUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.image,
          sentAt: Timestamp.fromDate(
            chatMessage.createdAt,
          ),
        );
      }
    } else {
      message = Message(
        senderId: currentChatUser!.id,
        content: chatMessage.text,
        messageType: MessageType.text,
        sentAt: Timestamp.fromDate(
          chatMessage.createdAt,
        ),
      );
    }

    await FireBaseMethods()
        .addChatMessages(message!, currentChatUser!.id, otherChatUser!.id);
  }

  List<ChatMessage> getChatMessages(List<Message> message) {
    List<ChatMessage> chatMsg = message.map((msg) {
      if (msg.messageType == MessageType.image) {
        return ChatMessage(
          // text: msg.content,
          user: msg.senderId == widget.currentUser.uid
              ? currentChatUser!
              : otherChatUser!,
          createdAt: msg.sentAt.toDate(),
          medias: [
            ChatMedia(
              url: msg.content,
              fileName: '',
              type: MediaType.image,
            ),
          ],
        );
      } else {
        return ChatMessage(
          text: msg.content,
          user: msg.senderId == widget.currentUser.uid
              ? currentChatUser!
              : otherChatUser!,
          createdAt: msg.sentAt.toDate(),
        );
      }
    }).toList();
    return chatMsg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: _userAppBar(),
        body: _userChatBody());
  }

  Future<void> _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select image from'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  pickedImage = file;
                });
                await _handlePickedImage();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  pickedImage = file;
                });
                await _handlePickedImage();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handlePickedImage() async {
    if (pickedImage != null) {
      String imageUrl = await FireBaseMethods()
          .mediaUrl(currentChatUser!.id, otherChatUser!.id, pickedImage!);

      if (imageUrl != '') {
        ChatMessage chatMessage = ChatMessage(
          user: currentChatUser!,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(url: imageUrl, fileName: '', type: MediaType.image),
          ],
        );

        await sendMessage(chatMessage);
        setState(() {
          pickedImage = null;
        });
      }
    }
  }

  Widget _userChatBody() {
    return StreamBuilder(
        stream: FireBaseMethods()
            .getUserChat(currentChatUser!.id, otherChatUser!.id),
        builder: ((context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];
          if (chat?.messages != null && chat != null) {
            messages = getChatMessages(chat.messages);
            messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          }
          return DashChat(
            messageOptions: MessageOptions(
              currentUserContainerColor: Color.fromARGB(255, 160, 243, 213),
              currentUserTextColor: primaryColor,
              showOtherUsersAvatar: true,
              showTime: true,
              timePadding: EdgeInsets.only(top: 4),
              containerColor: Color.fromARGB(255, 162, 218, 244),
              messageTextBuilder: (ChatMessage message,
                  ChatMessage? previousMessage, ChatMessage? nextMessage) {
                return Column(
                  children: [
                    Text(
                      message.text,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(message.createdAt),
                      style: const TextStyle(
                        fontSize:
                            12.0, // Set your desired font size for the time here
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              },
              // messageTimeBuilder: (ChatMessage message, bool showTime) {
              //   return Text(
              //     DateFormat('hh:mm a').format(message.createdAt),
              //     style: TextStyle(
              //       fontSize:
              //           10.0, // Set your desired font size for the time here
              //       color: Colors.grey,
              //     ),
              //   );
              // },
            ),
            inputOptions: InputOptions(
              // alwaysShowSend: true,
              inputTextStyle: const TextStyle(color: primaryColor),
              inputDecoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: const TextStyle(color: Colors.black87),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      const BorderSide(color: Colors.black45, width: 2.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              ),
              trailing: [_mediaPickButton(context)],
            ),
            currentUser: currentChatUser!,
            onSend: sendMessage,
            messages: messages,
          );
        }));
  }

  Widget _mediaPickButton(BuildContext context) {
    return IconButton(
      onPressed: () => _selectImage(context),
      icon: const Icon(
        Icons.image,
        color: Colors.deepPurpleAccent,
      ),
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
                    color: primaryColor,
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
