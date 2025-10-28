import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/firestore_service.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String sectionId;
  const QuizScreen({super.key, required this.quizId, required this.sectionId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final firestore = FirestoreService();
  late Future<List<Question>> questionsFuture;
  final Map<String, int> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    questionsFuture =
        firestore.getQuestions(widget.quizId, widget.sectionId);
  }

  int correctCount = 0;
  bool isSubmitted = false;

  void submitAnswers(List<Question> questions) {
    int count = 0;
    for (var q in questions) {
      if (selectedAnswers[q.id] == q.correctIndex) {
        count++;
      }
    }
    setState(() {
      correctCount = count;
      isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Làm bài trắc nghiệm')),
      body: FutureBuilder<List<Question>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có câu hỏi.'));
          }

          final questions = snapshot.data!;

          return ListView.builder(
            itemCount: questions.length + 1,
            itemBuilder: (context, index) {
              if (index == questions.length) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: isSubmitted
                        ? null
                        : () => submitAnswers(questions),
                    child: const Text('Nộp bài'),
                  ),
                );
              }

              final q = questions[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Câu ${index + 1}: ${q.text}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(q.options.length, (optIndex) {
                        return RadioListTile<int>(
                          value: optIndex,
                          groupValue: selectedAnswers[q.id],
                          onChanged: (value) {
                            if (isSubmitted) return;
                            setState(() {
                              selectedAnswers[q.id] = value!;
                            });
                          },
                          title: Text(q.options[optIndex]),
                        );
                      }),
                      if (isSubmitted)
                        Text(
                          selectedAnswers[q.id] == q.correctIndex
                              ? '✅ Đúng'
                              : '❌ Sai (Đáp án đúng: ${q.options[q.correctIndex]})',
                          style: TextStyle(
                            color: selectedAnswers[q.id] == q.correctIndex
                                ? Colors.green
                                : Colors.red,
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: isSubmitted
          ? Container(
        color: Colors.blueGrey[50],
        padding: const EdgeInsets.all(16),
        child: Text(
          'Kết quả: $correctCount câu đúng / ${selectedAnswers.length}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )
          : null,
    );
  }
}
