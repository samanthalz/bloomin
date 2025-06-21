import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/tracker';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Calendar and tracking features")),
    );
  }
}
