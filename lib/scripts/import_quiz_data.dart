import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> importQuizData() async {
  final firestore = FirebaseFirestore.instance;

  // Đọc file JSON từ thư mục assets
  final String jsonData = await rootBundle.loadString('assets/basic_computer_quiz.json');
  final Map<String, dynamic> data = json.decode(jsonData);

  final quizRef = firestore.collection('quizzes').doc('quiz_computer_basic');
  await quizRef.set({
    'title': data['title'],
    'description': data['description'],
  });

  final sections = data['sections'] as Map<String, dynamic>;
  for (final sectionKey in sections.keys) {
    final section = sections[sectionKey];
    final sectionRef = quizRef.collection('sections').doc(sectionKey);
    await sectionRef.set({'name': section['name']});

    final questions = section['questions'] as List<dynamic>;
    for (var question in questions) {
      await sectionRef.collection('questions').add({
        'question': question['question'],
        'options': question['options'],
        'correctIndex': question['correctIndex'],
      });
    }
  }

  print('✅ Import quiz successfully!');
}
