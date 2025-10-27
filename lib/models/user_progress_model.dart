class SectionProgress {
  final bool completed;
  final int correct;
  final int total;

  SectionProgress({
    required this.completed,
    required this.correct,
    required this.total,
  });

  Map<String, dynamic> toMap() => {
    'completed': completed,
    'correct': correct,
    'total': total,
  };

  factory SectionProgress.fromMap(Map<String, dynamic> data) {
    return SectionProgress(
      completed: data['completed'] ?? false,
      correct: data['correct'] ?? 0,
      total: data['total'] ?? 0,
    );
  }
}
