import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/routs/approuts.dart';
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
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getAllUsers()
      ..getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, data, _) {
      if (data.isLoading) {
        return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: _chatsAppBar(context, data),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (data.getUsers.isEmpty) {
        return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: _chatsAppBar(context, data),
          body: const Center(
            child: Text(
              "No users found.",
              style: TextStyle(color: primaryColor),
            ),
          ),
        );
      }

      List<UserDetails> users = data.getUsers;
      return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: _chatsAppBar(context, data),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.allAvailableUsersRoute);
              },
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

  AppBar _chatsAppBar(BuildContext context, FirebaseProvider data) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: mobileBackgroundColor,
      title: const Text(
        "Chats",
        style: TextStyle(color: primaryColor),
      ),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              prefixIcon: const Icon(
                Icons.search,
                color: mobileBackgroundColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white70,
              contentPadding: const EdgeInsets.only(top: 12.0),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text(
                        'Do you want to signout?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      children: [
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await data.userSignOut();
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.exit_to_app,
              size: 32,
              color: primaryColor,
            ))
      ],
    );
  }
}
