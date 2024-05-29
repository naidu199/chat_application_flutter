import 'package:chat_application/screens/auth/loginscreen.dart';
import 'package:chat_application/screens/auth/signupscreen.dart';
import 'package:chat_application/screens/chats/all_avaiable_users.dart';
import 'package:chat_application/screens/chats_screen.dart';
import 'package:path/path.dart';
// import 'package:path/path.dart';

class AppRoutes {
  static const String loginRoute = '/loginscreen';
  static const String signupRoute = '/signupscreen';
  static const String chatsScreenRoute = '/chats_screen';
  static const String allAvailableUsersRoute = '/all_avaiable_users';
  static final routes = {
    loginRoute: (context) => const LoginScreen(),
    signupRoute: (context) => const SignUpScreen(),
    chatsScreenRoute: (context) => const ChatsScreen(),
    allAvailableUsersRoute: (context) => const AllAvailbleUsers(),
  };
}
