class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromMap(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctIndex: data['correctIndex'] ?? 0,
    );
  }
}
