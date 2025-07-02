import 'package:flutter/material.dart';
import 'payment_page.dart';

class EnterAmountPage extends StatefulWidget {
  const EnterAmountPage({super.key});

  @override
  State<EnterAmountPage> createState() => _EnterAmountPageState();
}

class _EnterAmountPageState extends State<EnterAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  final double padCost = 4.50; // 1 packet of pad = RM4.50

  double get _calculatedPacks {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount / padCost;
  }

  void _setQuickAmount(double value) {
    setState(() {
      _amountController.text = value.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Donation Amount")),
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
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  [10, 20, 50, 100].map((amt) {
                    return ElevatedButton(
                      onPressed: () => _setQuickAmount(amt.toDouble()),
                      child: Text("RM $amt"),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              "1 packet of sanitary pad costs RM ${padCost.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "Your donation can buy approximately ${_calculatedPacks.floor()} packet(s) of pads",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PaymentPage(amount: _amountController.text),
                    ),
                  );
                }
              },
              child: const Text("Continue to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Implement this library.
