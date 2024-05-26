import 'package:chat_application/screens/auth/loginscreen.dart';
import 'package:chat_application/screens/auth/signupscreen.dart';
// import 'package:path/path.dart';

class AppRoutes {
  static const String loginRoute = '/loginscreen';
  static const String signupRoute = '/signupscreen';
  static final routes = {
    loginRoute: (context) => const LoginScreen(),
    signupRoute: (context) => const SignUpScreen(),
  };
}
