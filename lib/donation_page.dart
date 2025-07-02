import 'package:flutter/material.dart';
import 'enter_amount_page.dart';
import 'package:bloomin/widgets/bottom_nav_bar.dart';

class DonationPage extends StatefulWidget {
  static const routeName = '/donate';

  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7C1ED),
        title: const Text("Donate"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Donation History",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(color: Color(0xFFBBAACC), thickness: 1.2),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 12, // More than 8 to show scrollability
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFFE7DAF5),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: Color(0xFF735276),
                        ),
                        title: Text(
                          "Donation RM ${10 * (index + 1)}",
                          style: const TextStyle(color: Color(0xFF29264C)),
                        ),
                        subtitle: const Text(
                          "Date: 2024-06-30",
                          style: TextStyle(color: Color(0xFF786B89)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EnterAmountPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Donate Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
