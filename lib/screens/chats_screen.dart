import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/routs/approuts.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:chat_application/widgets/new_user_item.dart';
import 'package:chat_application/widgets/search_users.dart';
import 'package:chat_application/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  String searchText = '';

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUser()
      ..getAllUserAvailable();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchText = query;
      isSearch = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, data, _) {
      return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: _chatsAppBar(context, data),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 110, 245, 196),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.allAvailableUsersRoute);
              },
              child: const Icon(
                Icons.message,
                size: 32,
                color: primaryColor,
              )),
          body: data.isLoading || data.getCurrentUser == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : data.getUsers!.isEmpty
                  ? _noUserFound(context, data) // if no user found
                  : _allUserBody(context, data));
    });
  }

  Widget _noUserFound(constext, FirebaseProvider value) {
    List<UserDetails> allUserDetails = value.getAvailableUsers!;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "No users found.",
              style: TextStyle(color: primaryColor, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Select User",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: allUserDetails.length,
            itemBuilder: ((context, index) {
              UserDetails userDetails = allUserDetails[index];
              return NewUserItem(
                userDetails: userDetails,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _allUserBody(context, FirebaseProvider data) {
    List<UserDetails> users = data.getUsers!;
    return isSearch
        ? UserSearchScreen(searchText: searchController.text)
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: ((context, index) {
              UserDetails userDetails = users[index];
              return UserItem(
                userDetails: userDetails,
              );
            }));
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
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 46,
            child: TextField(
              onChanged: _onSearchChanged,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                prefixIcon: const Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 187, 245, 224),
                contentPadding: const EdgeInsets.only(top: 8.0),
              ),
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
                            Navigator.of(context)
                                .pushNamed(AppRoutes.onBoardingRoute);
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
