import 'package:flutter/material.dart';
import 'quiz_data.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;
  const QuizPage({super.key, required this.quiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _idx = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  void _pick(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == widget.quiz.questions[_idx].correct) _score++;
    });
  }

  void _next() {
    if (!_answered) return;
    if (_idx < widget.quiz.questions.length - 1) {
      setState(() {
        _idx++;
        _selected = null;
        _answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() async {
    final again = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Finished'),
        content: Text('You scored $_score / ${widget.quiz.questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Play again'),
          ),
        ],
      ),
    );

    if (again ?? false) {
      setState(() {
        _idx = 0;
        _score = 0;
        _selected = null;
        _answered = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz.questions[_idx];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7), // Main app background
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: const Color(0xFFF89BA3), // App pink
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_idx + 1}/${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              q.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(q.options.length, (i) {
              Color? cardColor;
              if (_answered) {
                if (i == q.correct) {
                  cardColor = Colors.green[200];
                } else if (i == _selected) {
                  cardColor = Colors.red[200];
                }
              } else if (_selected == i) {
                cardColor = const Color(0xFFF6E3F7); // soft pink for selection
              }

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(q.options[i]),
                  onTap: () => _pick(i),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF), // App purple
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _answered ? _next : null,
                child: Text(
                  _idx == widget.quiz.questions.length - 1 ? 'Finish' : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
