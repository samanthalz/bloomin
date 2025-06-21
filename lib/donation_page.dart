import 'package:flutter/material.dart';

class DonationPage extends StatelessWidget {
  static const routeName = '/donate';

  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate")),
      body: const Center(child: Text("TnG QR and donation options")),
    );
  }
}
