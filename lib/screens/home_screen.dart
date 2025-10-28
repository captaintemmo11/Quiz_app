import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/firestore_service.dart';
import 'section_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách đề trắc nghiệm')),
      body: FutureBuilder<List<Quiz>>(
        future: firestore.getAllQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có đề thi nào.'));
          }

          final quizzes = snapshot.data!;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return ListTile(
                title: Text(quiz.title),
                subtitle: Text(quiz.description),
                leading: const Icon(Icons.assignment),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionListScreen(quiz: quiz),
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
