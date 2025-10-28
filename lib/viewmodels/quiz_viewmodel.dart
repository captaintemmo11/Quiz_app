import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/user_progress_model.dart';
import '../services/firestore_service.dart';

class QuizViewModel extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Quiz> quizzes = [];
  Map<String, SectionProgress> userProgress = {};

  /// 🔹 Load tất cả đề thi
  Future<void> loadQuizzes() async {
    quizzes = await _service.getAllQuizzes();
    notifyListeners();
  }

  /// 🔹 Load tiến độ người dùng trong 1 đề thi
  Future<void> loadUserProgress(String userId, String quizId) async {
    userProgress = await _service.getUserProgress(userId, quizId);
    notifyListeners();
  }

  /// 🔹 Lưu tiến độ sau khi hoàn thành 1 phần thi
  Future<void> saveProgress(
      String userId, String quizId, String sectionId, int correct, int total) async {
    final progress = SectionProgress(
      completed: true,
      correct: correct,
      total: total,
    );

    await _service.saveUserProgress(userId, quizId, sectionId, progress);
    userProgress[sectionId] = progress;
    notifyListeners();
  }
}
