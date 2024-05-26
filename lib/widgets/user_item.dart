import 'package:chat_application/models/user.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatelessWidget {
  final UserDetails userDetails;
  const UserItem({
    super.key,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(userDetails.profileUrl),
      ),
      title: Text(userDetails.uid),
      subtitle: Text("lastseen ${timeago.format(userDetails.lastseen)}"),
    );
  }
}
