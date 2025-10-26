class Quiz {
  final String id;
  final String title;
  final String description;

  Quiz({required this.id, required this.title, required this.description});

  factory Quiz.fromMap(Map<String, dynamic> data, String documentId) {
    return Quiz(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
