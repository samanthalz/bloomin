import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance.ref();

  String? username;
  String? email;
  int? lastDispenseMillis;
  bool _mockScanWritten = false;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    listenToUserData();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  void listenToUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    db.child('users/$uid').onValue.listen((event) async {
      final data = event.snapshot.value as Map?;
      if (data == null) return;

      final currentEmail = FirebaseAuth.instance.currentUser?.email;
      final dbEmail = data['email'];
      final dbLastDispense = data['lastDispense'];

      if (currentEmail != null && dbEmail != currentEmail) {
        await db.child('users/$uid').update({'email': currentEmail});
      }

      if (!_mockScanWritten && dbLastDispense == null) {
        _mockScanWritten = true;
        await updateLastDispense();
      }

      setState(() {
        username = data['username'] ?? 'N/A';
        email = currentEmail ?? 'N/A';
        if (dbLastDispense != null) {
          lastDispenseMillis = dbLastDispense;
        }
      });
    });
  }

  Future<void> fetchUserDetails() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null) {
        final snapshot = await db.child('users/${refreshedUser.uid}').get();
        final data = snapshot.value as Map?;

        final currentEmail = refreshedUser.email;
        final dbEmail = data?['email'];
        final dbLastDispense = data?['lastDispense'];

        if (currentEmail != null && dbEmail != currentEmail) {
          await db.child('users/${refreshedUser.uid}').update({
            'email': currentEmail,
          });
        }

        if (!_mockScanWritten && dbLastDispense == null) {
          _mockScanWritten = true;
          await updateLastDispense();
        }

        setState(() {
          username = data?['username'] ?? 'N/A';
          email = currentEmail ?? 'N/A';
          lastDispenseMillis = dbLastDispense;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Future<void> updateLastDispense() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (uid != null) {
      await db.child('users/$uid').update({'lastDispense': now});
      setState(() {
        lastDispenseMillis = now;
      });
    }
  }

  Widget _buildLabelRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF5D2E46),
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCooldownTimer() {
    if (lastDispenseMillis == null) return const SizedBox();

    final last = DateTime.fromMillisecondsSinceEpoch(lastDispenseMillis!);
    final now = DateTime.now();
    final diff = now.difference(last);
    final remaining = Duration(hours: 2) - diff;

    if (remaining.isNegative) {
      return const Column(
        children: [
          SizedBox(height: 12),
          Icon(Icons.check_circle, color: Colors.green, size: 32),
          SizedBox(height: 8),
          Text(
            "You can now use the dispenser again.",
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
        ],
      );
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Column(
      children: [
        const SizedBox(height: 12),
        const Icon(Icons.timer, color: Colors.red, size: 32),
        const SizedBox(height: 8),
        const Text(
          "Please wait before using the dispenser again:",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
        const SizedBox(height: 4),
        Text(
          "${hours.toString().padLeft(2, '0')}h "
          "${minutes.toString().padLeft(2, '0')}m "
          "${seconds.toString().padLeft(2, '0')}s",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7), // pastel yellow
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        backgroundColor: const Color(0xFFF89BA3), // medium pink
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              color: const Color(0xFFFAD3D8), // pale pink card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    _buildLabelRow("Username", username ?? ''),
                    _buildLabelRow("Email", email ?? ''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  fetchUserDetails();
                },
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Edit Details",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF85A0E8), // light blue
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your QR Code",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            if (uid != null)
              QrImageView(
                data: uid,
                version: QrVersions.auto,
                size: 160.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 16),
            _buildCooldownTimer(),
          ],
        ),
      ),
    );
  }
}
