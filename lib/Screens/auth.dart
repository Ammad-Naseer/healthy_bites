import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_bites/Screens/Login_Screen.dart';
import 'package:healthy_bites/Screens/navBarRoots.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
        backgroundColor: Colors.transparent,
        body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges().cast<User>(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return const NavBarRoots();
              } else {
                return const LoginScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
