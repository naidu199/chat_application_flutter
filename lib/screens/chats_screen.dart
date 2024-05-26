import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, data, _) {
      List<UserDetails> users = data.getUsers;
      return Scaffold(
          appBar: AppBar(
            title: const Text("Chats"),
            centerTitle: false,
          ),
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserItem(userDetails: users[index]);
            },
          ));
    });
  }
}
