class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct;
  QuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
  });
  factory QuizQuestion.fromMap(Map<String, dynamic> m) => QuizQuestion(
    question: m['question'],
    options: List<String>.from(m['options']),
    correct: m['correct'],
  );
}
