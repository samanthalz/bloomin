import 'package:flutter/material.dart';

class PeriodTrackerPage extends StatelessWidget {
  static const routeName = '/period'; // ✅ Add this line

  const PeriodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Period Tracker Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

