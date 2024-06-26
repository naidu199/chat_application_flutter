import 'dart:typed_data';

import 'package:chat_application/backend/auth/auth_signup.dart';
import 'package:chat_application/routs/approuts.dart';
import 'package:chat_application/utils/colors.dart';
import 'package:chat_application/utils/consts.dart';
import 'package:chat_application/utils/image_picker.dart';
import 'package:chat_application/utils/toast.dart';
import 'package:chat_application/widgets/text_field_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  Uint8List? profileImage;
  bool _islaoding = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    // biocontroller.dispose();
    usernamecontroller.dispose();
    namecontroller.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      profileImage = image;
    });
  }

  void signupUser() async {
    setState(() {
      _islaoding = true;
    });
    String response = await AuthSignUp().signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernamecontroller.text.trim(),
        name: namecontroller.text.trim(),
        profilepic: profileImage);
    // print(res);
    if (response != "success") {
      // ignore: use_build_context_synchronously
      toastMessage(context, response);
    }
    if (response == 'success') {
      Navigator.of(context).pushNamed(AppRoutes.loginRoute);
    }
    setState(() {
      _islaoding = false;
    });
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/chatting.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Linkup',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 31, 218, 149),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(profileImage!),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                          ),
                    Positioned(
                      bottom: -1,
                      right: -10,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Username',
                  textEditingController: usernamecontroller,
                  textInputType: TextInputType.text,
                  isPassword: false,
                ),
                const SizedBox(height: 12),
                TextFieldInput(
                  hintText: 'Name',
                  textEditingController: namecontroller,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 12),
                TextFieldInput(
                  hintText: 'Email or Phone Number',
                  textEditingController: emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFieldInput(
                  hintText: 'Password',
                  textEditingController: passwordController,
                  isPassword: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: _islaoding
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              color: primaryColor,
                            ),
                          )
                        : const Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?  ",
                        style: TextStyle(color: primaryColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.loginRoute);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
