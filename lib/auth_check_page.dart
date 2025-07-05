import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthCheckPage extends StatelessWidget {
  final PageController controller;

  const AuthCheckPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.emailVerified) {
          return const HomePage(); // user is logged in and verified
        }

        return LoginPage(controller: controller); // default to login
      },
    );
  }
}
