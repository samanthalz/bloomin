import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'payment_page.dart';

class EnterAmountPage extends StatefulWidget {
  const EnterAmountPage({super.key});

  @override
  State<EnterAmountPage> createState() => _EnterAmountPageState();
}

class _EnterAmountPageState extends State<EnterAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  final double padCost = 4.50;
  final List<double> quickAmounts = [10, 20, 50, 100, 150, 250];

  double get _calculatedPacks {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount / padCost;
  }

  void _setQuickAmount(double value) {
    setState(() {
      _amountController.text = value.toStringAsFixed(2);
    });
  }

  Future<void> _saveDonationAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final amount = _amountController.text;
    final timestamp = DateTime.now().toIso8601String();

    try {
      await FirebaseDatabase.instance.ref('donations/${user.uid}').push().set({
        'amount': amount,
        'date': timestamp,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentPage(amount: amount)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving donation: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Donation Amount"),
        backgroundColor: const Color(0xFF9F7BFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Donation Amount",
                prefixText: "RM ",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  quickAmounts.map((amount) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 28,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F7BFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _setQuickAmount(amount),
                        child: Text("RM ${amount.toInt()}"),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBFF),
                border: Border.all(color: Color(0xFF9F7BFF)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sanitary Pad Cost Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• 1 packet of sanitary pad costs RM ${padCost.toStringAsFixed(2)}.",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "• Your donation can provide approximately ",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        TextSpan(
                          text: "${_calculatedPacks.floor()}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const TextSpan(
                          text: " packet(s) of pads.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed:
                    _amountController.text.isNotEmpty
                        ? _saveDonationAndNavigate
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                child: const Text("Continue to Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
