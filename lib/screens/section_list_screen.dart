import 'package:flutter/material.dart';
import '../models/section_model.dart';
import '../models/user_progress_model.dart';

class SectionListScreen extends StatelessWidget {
  final List<Section> sections;
  final Map<String, SectionProgress> progress;
  final Function(Section) onStartSection;
  final Function(Section) onViewResult;
  final Function(Section) onRetry;

  const SectionListScreen({
    super.key,
    required this.sections,
    required this.progress,
    required this.onStartSection,
    required this.onViewResult,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Các phần thi")),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final sectionProgress = progress[section.id];
          final completed = sectionProgress?.completed ?? false;

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(section.title),
              subtitle: completed
                  ? Text("Hoàn thành: ${sectionProgress!.correct}/${sectionProgress.total} đúng")
                  : const Text("Chưa làm"),
              trailing: completed
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () => onViewResult(section),
                      child: const Text("Xem kết quả")),
                  const SizedBox(width: 8),
                  OutlinedButton(
                      onPressed: () => onRetry(section),
                      child: const Text("Làm lại")),
                ],
              )
                  : ElevatedButton(
                  onPressed: () => onStartSection(section),
                  child: const Text("Làm bài")),
            ),
          );
        },
      ),
    );
  }
}
