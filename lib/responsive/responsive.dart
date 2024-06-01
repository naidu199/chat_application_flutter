import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/responsive/web_screen_layout.dart';
import 'package:chat_application/screens/chats_screen.dart';
import 'package:chat_application/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > webscreensize) {
              return const WebScreenLayout();
            } else {
              return const ChatsScreen();
            }
          });
  }
}
