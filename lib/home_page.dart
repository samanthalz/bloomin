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
  bool _isFirstLoad = true; // ensure it runs once

  final List<Widget> _pages = [
    Center(child: Text('Home Page')),
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
