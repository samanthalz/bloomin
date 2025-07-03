import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bloomin/widgets/bottom_nav_bar.dart';
import 'period_tracker_page.dart';
import 'donation_page.dart';
import 'learning_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isFirstLoad = true;

  final List<Widget> _pages = [
    const HomeDashboard(),
    const PeriodTrackerPage(),
    const DonationPage(),
    const LearningPage(),
    const ProfilePage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['selectedIndex'] != null) {
        _currentIndex = args['selectedIndex'] as int;
      }
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users/${user.uid}/username');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot.value.toString();
        });
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5), // Light yellow background
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLoading
                  ? "Loading..."
                  : userName != null
                  ? "Welcome back, $userName 👋"
                  : "Welcome back 👋",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A4A24), // Brownish for contrast
              ),
            ),
            const SizedBox(height: 20),

            // Quick Access Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickAccessTile(
                  icon: Icons.calendar_today,
                  label: "Tracker",
                  targetIndex: 1,
                ),
                _QuickAccessTile(
                  icon: Icons.volunteer_activism,
                  label: "Donate",
                  targetIndex: 2,
                ),
                _QuickAccessTile(
                  icon: Icons.school,
                  label: "Learn",
                  targetIndex: 3,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Motivational Quote Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "“Your body is your home. Treat it with love.” 💖",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tip of the Day
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "🌸 Tip of the Day:\nStay hydrated during your cycle and rest when needed.",
                style: TextStyle(fontSize: 15, color: Colors.pink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int targetIndex;

  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.targetIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          HomePage.routeName,
          arguments: {'selectedIndex': targetIndex},
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.pink[600]),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Icon(Icons.arrow_forward, size: 18, color: Colors.pink[600]),
          ],
        ),
      ),
    );
  }
}
