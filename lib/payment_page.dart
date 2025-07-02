import 'package:flutter/material.dart';
import 'donation_page.dart';

class PaymentPage extends StatelessWidget {
  final String amount;
  const PaymentPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Scan QR to donate RM $amount",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/img/tng_qr.jpg',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DonationPage()),
                  (route) => false,
                );
              },
              child: const Text("Back to Donation History"),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Implement this library.
