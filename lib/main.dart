import 'package:flutter/material.dart';
import 'package:bloomin/login_page.dart';
import 'package:bloomin/signup_page.dart';
import 'package:bloomin/home_page.dart';
import 'package:bloomin/donation_page.dart';
import 'package:bloomin/learning_page.dart';
import 'package:bloomin/profile_page.dart';
import 'package:bloomin/period_tracker_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloomin/forgot_password_page.dart';

import 'auth_check_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomin App',

      home: AuthCheckPage(controller: pageController),

      routes: {
        LoginPage.routeName: (context) => LoginPage(controller: pageController),
        SignupPage.routeName:
            (context) => SignupPage(controller: pageController),
        HomePage.routeName: (context) => const HomePage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        LearningPage.routeName: (context) => const LearningPage(),
        DonationPage.routeName: (context) => const DonationPage(),
        PeriodTrackerPage.routeName: (context) => const PeriodTrackerPage(),
        ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
      },
    );
  }
}
