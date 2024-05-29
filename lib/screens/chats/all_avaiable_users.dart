import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:chat_application/widgets/new_user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllAvailbleUsers extends StatefulWidget {
  const AllAvailbleUsers({super.key});

  @override
  State<AllAvailbleUsers> createState() => _AllAvailbleUsersState();
}

class _AllAvailbleUsersState extends State<AllAvailbleUsers> {
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getAllUserAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, value, _) {
      return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: mobileBackgroundColor,
          title: Container(
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
        body: value.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : value.getAvailableUsers.isEmpty
                ? const Center(
                    child: Text("No users found."),
                  )
                : _allUserBody(context, value),
      );
    });
  }

  Widget _allUserBody(context, FirebaseProvider value) {
    List<UserDetails> allUserDetails = value.getAvailableUsers;
    return ListView.builder(
        itemCount: allUserDetails.length,
        itemBuilder: ((context, index) {
          UserDetails userDetails = allUserDetails[index];
          return NewUserItem(
            userDetails: userDetails,
          );
        }));
  }
}
