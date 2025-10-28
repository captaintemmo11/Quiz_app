import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/firestore_service.dart';
import 'quiz_screen.dart'; // 👉 nhớ import màn hình Quiz

class SectionListScreen extends StatefulWidget {
  final Quiz quiz;
  const SectionListScreen({super.key, required this.quiz});

  @override
  State<SectionListScreen> createState() => _SectionListScreenState();
}

class _SectionListScreenState extends State<SectionListScreen> {
  final firestore = FirestoreService();
  late Future<List<String>> sectionsFuture;

  @override
  void initState() {
    super.initState();
    sectionsFuture = firestore.getSections(widget.quiz.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: FutureBuilder<List<String>>(
        future: sectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có phần nào.'));
          }

          final sections = snapshot.data!;
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              return ListTile(
                title: Text('Phần ${index + 1}: $section'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  print('DEBUG: Tapped section "$section"');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        quizId: widget.quiz.id,
                        sectionId: section,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
