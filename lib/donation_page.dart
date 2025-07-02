import 'package:flutter/material.dart';
import 'enter_amount_page.dart';

class DonationPage extends StatelessWidget {
  static const routeName = '/donate';

  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Donation History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Placeholder
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text("Donation RM ${10 * (index + 1)}"),
                    subtitle: Text("Date: 2024-06-30"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EnterAmountPage()),
                );
              },
              child: const Text("Donate Now"),
            ),
          ],
        ),
      ),
    );
  }
}
