import 'package:chat_application/backend/provider/firebase_provider.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/responsive/responsive.dart';
import 'package:chat_application/routs/approuts.dart';
import 'package:chat_application/screens/auth/loginscreen.dart';
import 'package:chat_application/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        routes: AppRoutes.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return toastMessage(context, "reload the app");
              }
              if (snapshot.hasData) {
                return const ResponsiveLayout();
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
