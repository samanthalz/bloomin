import 'package:flutter/material.dart';

class LearningPage extends StatelessWidget {
  static const routeName = '/learning';

  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning")),
      body: const Center(child: Text("Short videos and notes")),
    );
  }
}
