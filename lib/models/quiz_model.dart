import 'section_model.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Section> sections;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.sections,
  });

  factory Quiz.fromMap(Map<String, dynamic> data, String id, List<Section> sections) {
    return Quiz(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      sections: sections,
    );
  }
}
