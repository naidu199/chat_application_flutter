import 'package:chat_application/backend/firebase_methods.dart';
import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/screens/chats/user_chat_screen.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatelessWidget {
  final UserDetails userDetails;
  // final Function onTap;
  const UserItem({
    super.key,
    required this.userDetails,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    UserDetails user = Provider.of<FirebaseProvider>(context).getCurrentUser!;
    // print("user item $user");
    return InkWell(
      child: ListTile(
        onTap: () async {
          var exist =
              await FireBaseMethods().checkChatExist(user.uid, userDetails.uid);
          if (!exist) {
            await FireBaseMethods().createNewChat(user.uid, userDetails.uid);
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserChatScreen(
                userDetails: userDetails,
                currentUser: user,
              ),
            ),
          );
        },
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
