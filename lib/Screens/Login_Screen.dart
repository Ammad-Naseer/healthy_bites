// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bites/Models/colors.dart';
import 'package:healthy_bites/Screens/navBarRoots.dart';
import 'package:healthy_bites/Screens/SignUP_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_bites/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> userLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Fluttertoast.showToast(
        msg: "Login successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.darkGreen,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavBarRoots(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "User not found";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many login attempts. Please try again later.";
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
                      const Text("Don't have any account ? ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUPScreen(),
                              ));
                        },
                        child: const Text("Sign up",
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/foodicon.png',
                      height: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Login",
                        style: GoogleFonts.sigmarOne(
                            textStyle: const TextStyle(
                                color: MyColors.green, fontSize: 30)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          AuthTextField(
                            controller: emailController,
                            hintText: "Enter your email",
                            icon: Icons.email_outlined,
                            showSuffixIcon: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                                var pref =
                                    await SharedPreferences.getInstance();
                                pref.setBool("Login", true);
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                });
                                userLogin(email, password);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill all detail",
                                    backgroundColor: Colors.redAccent);
                              }
                            },
                            child: Text(
                              'Login',
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
            ),
          )),
    );
  }
}
