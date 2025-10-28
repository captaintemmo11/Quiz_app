class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromMap(Map<String, dynamic> data, String documentId) {
    return Question(
      id: documentId,
      text: data['text'] ?? data['question'] ?? '', // ✅ đọc cả 2 key
      options: List<String>.from(data['options'] ?? []),
      correctIndex: data['correctIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correctIndex': correctIndex,
    };
  }
}
