import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeriodTrackerPage extends StatefulWidget {
  static const routeName = '/period';
  const PeriodTrackerPage({super.key});

  @override
  State<PeriodTrackerPage> createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStart;
  DateTime? _selectedEnd;

  bool _isLogging = false;
  bool _isEditing = false;
  DateTimeRange? _editingOriginalRange;

  final List<DateTimeRange> _loggedRanges = [];

  bool _isDayLogged(DateTime day) {
    return _loggedRanges.any(
      (range) => !day.isBefore(range.start) && !day.isAfter(range.end),
    );
  }

  DateTimeRange? _getRangeContaining(DateTime day) {
    for (var range in _loggedRanges) {
      if (!day.isBefore(range.start) && !day.isAfter(range.end)) {
        return range;
      }
    }
    return null;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      if (_isLogging) {
        if (_selectedStart == null ||
            (_selectedStart != null && _selectedEnd != null)) {
          _selectedStart = selectedDay;
          _selectedEnd = null;
        } else if (selectedDay.isBefore(_selectedStart!)) {
          _selectedStart = selectedDay;
        } else {
          _selectedEnd = selectedDay;
        }
      } else {
        final existingRange = _getRangeContaining(selectedDay);
        if (existingRange != null) {
          _isLogging = true;
          _isEditing = true;
          _selectedStart = existingRange.start;
          _selectedEnd = existingRange.end;
          _editingOriginalRange = existingRange;
        }
      }
    });
  }

  void _confirmLog() async {
    if (_selectedStart == null || _selectedEnd == null) return;

    final newRange = DateTimeRange(start: _selectedStart!, end: _selectedEnd!);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to save your period log.'),
        ),
      );
      return;
    }

    // Save to local state
    setState(() {
      if (_isEditing && _editingOriginalRange != null) {
        _loggedRanges.remove(_editingOriginalRange);
      }

      _loggedRanges.add(newRange);
      _isLogging = false;
      _isEditing = false;
      _selectedStart = null;
      _selectedEnd = null;
      _editingOriginalRange = null;
    });

    try {
      await _dbRef.child('period_logs').child(user.uid).push().set({
        'start': newRange.start.toIso8601String(),
        'end': newRange.end.toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error saving to database: $e');
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(_isEditing ? 'Period Updated' : 'Period Logged'),
            content: Text(
              'From ${_formatDate(newRange.start)} to ${_formatDate(newRange.end)}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation() {
    if (_editingOriginalRange == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Period Record'),
            content: const Text('Are you sure you want to delete this record?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _loggedRanges.remove(_editingOriginalRange);
                    _isLogging = false;
                    _isEditing = false;
                    _selectedStart = null;
                    _selectedEnd = null;
                    _editingOriginalRange = null;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDateField(String label, DateTime? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: date != null ? _formatDate(date) : '-',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildCycleInfo() {
    String? periodStatus;
    Color periodColor = Colors.grey;
    int? periodLength;

    if (_loggedRanges.isNotEmpty) {
      final sorted = [..._loggedRanges]
        ..sort((a, b) => a.start.compareTo(b.start));
      final latest = sorted.last;
      periodLength = latest.end.difference(latest.start).inDays + 1;
      periodStatus =
          (periodLength >= 3 && periodLength <= 7) ? "Normal" : "Abnormal";
      periodColor = periodStatus == "Normal" ? Colors.green : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Last Cycle Analysis",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            if (periodLength != null) ...[
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Previous period duration: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '$periodLength days',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Period Status: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: periodStatus!,
                      style: TextStyle(
                        fontSize: 16,
                        color: periodColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              const Text(
                'No period records found yet. Log your period to begin tracking your cycle.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                if (!_isLogging) return false;
                if (_selectedStart != null && _selectedEnd != null) {
                  return day.isAfter(
                        _selectedStart!.subtract(const Duration(days: 1)),
                      ) &&
                      day.isBefore(_selectedEnd!.add(const Duration(days: 1)));
                } else if (_selectedStart != null) {
                  return isSameDay(day, _selectedStart);
                }
                return false;
              },
              onDaySelected: _onDaySelected,
              onPageChanged:
                  (focusedDay) => setState(() => _focusedDay = focusedDay),
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.deepPurple,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.deepPurple,
                ),
                titleTextFormatter:
                    (date, locale) =>
                        '${_monthName(date.month)} ${date.year}', // 👈 Custom format
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return GestureDetector(
                    onTap: () async {
                      final picked = await showMonthPicker(
                        context: context,
                        initialDate: _focusedDay,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _focusedDay = picked;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_monthName(day.month)} ${day.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                  );
                },
                defaultBuilder: (context, day, _) {
                  final isLogged = _isDayLogged(day);
                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isLogged ? Colors.pink[100] : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isLogged ? Colors.pink[800] : Colors.black,
                        fontWeight:
                            isLogged ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            if (_isLogging)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isEditing
                            ? 'Edit Period Range'
                            : 'Select Period Range',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDateField("Start Date", _selectedStart),
                      _buildDateField("End Date", _selectedEnd),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed:
                                (_selectedStart != null && _selectedEnd != null)
                                    ? _confirmLog
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_selectedStart != null &&
                                          _selectedEnd != null)
                                      ? Colors.deepPurple[400]
                                      : Colors.grey,
                              foregroundColor:
                                  (_selectedStart != null &&
                                          _selectedEnd != null)
                                      ? Colors.white
                                      : Colors.black54,
                            ),
                            child: Text(_isEditing ? 'Update' : 'Confirm'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isLogging = false;
                                _isEditing = false;
                                _selectedStart = null;
                                _selectedEnd = null;
                                _editingOriginalRange = null;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          if (_isEditing) ...[
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                              ),
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              onPressed: _showDeleteConfirmation,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (!_isLogging)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLogging = true;
                      _isEditing = false;
                      _selectedStart = null;
                      _selectedEnd = null;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Log Period'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            _buildCycleInfo(),
          ],
        ),
      ),
    );
  }
}
