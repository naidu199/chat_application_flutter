import 'package:chat_application/screens/chats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            const SizedBox(
              width: 300,
              child: Card(
                child: ChatsScreen(),
              ),
            ),
            Expanded(
                child: Card(
              child: Container(
                child: Text('Messages'),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
