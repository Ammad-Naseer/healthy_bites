// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:healthy_bites/Models/colors.dart';
import 'package:healthy_bites/Screens/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../widgets/auth_text_field.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registration() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((_) {
        Fluttertoast.showToast(
          msg: "Registration successfully,Please Login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColors.darkGreen,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email";
      } else {
        errorMessage = "An error occurred, please try again later";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreen,
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: MyColors.darkGreen,
          content: Text(
            "An unexpected error occurred, please try again later",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.yellow.shade50
            : Colors.black,
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/bg.png'),
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: BottomAppBar(
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.green.shade400,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ? ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text("Login",
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      )
                    ],
                  )),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Lottie.asset('assets/signup.json', height: 180)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.sigmarOne(
                          textStyle: const TextStyle(
                              color: MyColors.green, fontSize: 30)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: nameController,
                          hintText: "Enter your name",
                          icon: Icons.person,
                          showSuffixIcon: false,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: emailController,
                          hintText: "Enter your email",
                          icon: Icons.email_outlined,
                          showSuffixIcon: false,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: passwordController,
                          hintText: "Enter your password",
                          icon: Icons.lock_outline,
                          showSuffixIcon: true,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var prefs = await SharedPreferences.getInstance();
                              prefs.setString(
                                  'myName', nameController.text.toString());
                              registration();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill all detail",
                                  backgroundColor: Colors.redAccent);
                            }
                          },
                          child: Text(
                            'Sign up',
                            style: GoogleFonts.sigmarOne(
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
