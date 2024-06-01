import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/widgets/new_user_item.dart';
import 'package:chat_application/utils/colors.dart';

class UserSearchScreen extends StatelessWidget {
  final String searchText;

  const UserSearchScreen({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Refresh the page',
              style: TextStyle(color: primaryColor),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        final List<DocumentSnapshot<Map<String, dynamic>>> userSnapshots =
            snapshot.data!.docs;
        final List<UserDetails> users =
            userSnapshots.map((doc) => UserDetails.fromSnapshot(doc)).toList();
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return NewUserItem(userDetails: users[index]);
          },
        );
      },
    );
  }
}
