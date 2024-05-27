import 'package:chat_application/backend/auth/auth_login.dart';
import 'package:chat_application/responsive/responsive.dart';
import 'package:chat_application/routs/approuts.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:chat_application/utils/consts.dart';
import 'package:chat_application/utils/toast.dart';
import 'package:chat_application/widgets/text_field_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });

    try {
      String response = await AuthLogin().login(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (!mounted) return; // Ensure the widget is still in the tree

      if (response != "success") {
        toastMessage(context, response);
      }

      setState(() {
        _isloading = false;
      });

      if (response == 'success') {
        Navigator.of(context).pushNamed(AppRoutes.chatsScreenRoute);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isloading = false;
        });
      }
      toastMessage(context, "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webscreensize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldInput(
              hintText: 'Email or Phone Number',
              textEditingController: emailController,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
              hintText: 'Password',
              textEditingController: passwordController,
              isPassword: true,
              textInputType: TextInputType.text,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor,
                ),
                child: _isloading
                    ? const Center(
                        child: CupertinoActivityIndicator(
                          radius: 12,
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(color: primaryColor, fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    "Don't have an account?  ",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.signupRoute);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      "signup",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
