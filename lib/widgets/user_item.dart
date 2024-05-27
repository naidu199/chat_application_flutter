import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/screens/chats/user_chat_screen.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatelessWidget {
  final UserDetails userDetails;
  const UserItem({
    super.key,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    UserDetails user = Provider.of<FirebaseProvider>(context).getcurrentUser;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserChatScreen(
            userDetails: userDetails,
            currentUser: user,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(userDetails.profileUrl),
        ),
        title: Text(
          userDetails.name,
          style: const TextStyle(color: primaryColor),
        ),
        subtitle: Text(
          "lastseen ${timeago.format(userDetails.lastseen)}",
          style: const TextStyle(color: primaryColor),
        ),
      ),
    );
  }
}
