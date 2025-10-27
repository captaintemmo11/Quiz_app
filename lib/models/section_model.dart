import 'question_model.dart';

class Section {
  final String id;
  final String title;
  final int order;
  final List<Question> questions;

  Section({
    required this.id,
    required this.title,
    required this.order,
    required this.questions,
  });

  factory Section.fromMap(Map<String, dynamic> data, String id, List<Question> questions) {
    return Section(
      id: id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      questions: questions,
    );
  }
}
