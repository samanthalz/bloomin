import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'enter_amount_page.dart';

class DonationPage extends StatefulWidget {
  static const routeName = '/donate';

  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final ScrollController _scrollController = ScrollController();
  final _database = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('donations/${user.uid}')
          .get()
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (snapshot.exists) {
        final Map data = snapshot.value as Map;
        final List<Map<String, dynamic>> fetched = [];

        data.forEach((key, value) {
          fetched.add({
            'id': key,
            'amount': value['amount'],
            'date': value['date'],
          });
        });

        setState(() {
          _donations = fetched;
          _isLoading = false;
        });
      } else {
        setState(() {
          _donations = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7), // pastel yellow
      appBar: AppBar(
        backgroundColor: const Color(0xFFF89BA3), // pink
        title: const Text(
          "Donate",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
                color: Color(0xFF5B4E6E), // dark pastel purple
              ),
            ),
            const Divider(color: Color(0xFFBBAACC), thickness: 1.2),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _donations.isEmpty
                      ? const Center(
                        child: Text(
                          "No donation history found.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                      : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 6,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _donations.length,
                          itemBuilder: (context, index) {
                            final donation = _donations[index];
                            final amount = donation['amount'];
                            final date = DateTime.tryParse(donation['date']);
                            final formattedDate =
                                date != null
                                    ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
                                    : "Unknown Date";

                            return Card(
                              color: const Color(0xFFF8CCD0), // light pink
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.history,
                                  color: Color(0xFF5B4E6E),
                                ),
                                title: Text(
                                  "Donation RM $amount",
                                  style: const TextStyle(
                                    color: Color(0xFF29264C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "Date: $formattedDate",
                                  style: const TextStyle(
                                    color: Color(0xFF786B89),
                                  ),
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
                  backgroundColor: const Color(0xFFF87E86), // dark pink
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
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
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
