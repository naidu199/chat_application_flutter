import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/colors.dart';
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
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    Provider.of<FirebaseProvider>(context, listen: false).getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, data, _) {
      if (data.isLoading) {
        return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            title: const Text("Chats"),
            centerTitle: false,
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (data.getUsers.isEmpty) {
        return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            title: const Text("Chats"),
            centerTitle: false,
          ),
          body: const Center(
            child: Text("No users found."),
          ),
        );
      }

      List<UserDetails> users = data.getUsers;
      return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text(
              "Chats",
              style: TextStyle(color: primaryColor),
            ),
            centerTitle: false,
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {},
              child: const Icon(
                Icons.message,
                size: 32,
                color: primaryColor,
              )),
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserItem(
                userDetails: users[index],
              );
            },
          ));
    });
  }
}
