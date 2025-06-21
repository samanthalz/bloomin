import 'package:flutter/material.dart';
import 'package:bloomin/login.dart';
// import other pages like home, signup etc.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomin App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFB3F1C1)),
        primarySwatch: Colors.teal,
      ),

      // 👇 Set default route to login
      initialRoute: LoginPage.routeName,

      // 👇 Register all your named routes here
      routes: {
        LoginPage.routeName: (context) => LoginPage(controller: pageController),
        // Add more pages as needed
        // MyHomePage.routeName: (context) => const MyHomePage(),
        // SignupPage.routeName: (context) => SignupPage(controller: pageController),
      },
    );
  }
}
