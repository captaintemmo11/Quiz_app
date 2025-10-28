import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/user_progress_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Lấy danh sách tất cả các đề thi
  Future<List<Quiz>> getAllQuizzes() async {
    final snapshot = await _db.collection('quizzes').get();
    return snapshot.docs.map((doc) {
      return Quiz.fromMap(doc.data(), doc.id, []);
    }).toList();
  }

  /// 🔹 Lấy danh sách section (phần thi) của 1 đề
  Future<List<String>> getSections(String quizId) async {
    final snapshot = await _db
        .collection('quizzes')
        .doc(quizId)
        .collection('sections')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// 🔹 Lấy danh sách câu hỏi của 1 section
  Future<List<Question>> getQuestions(String quizId, String sectionId) async {
    final snapshot = await _db
        .collection('quizzes')
        .doc(quizId)
        .collection('sections')
        .doc(sectionId)
        .collection('questions')
        .get();

    return snapshot.docs
        .map((doc) => Question.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// 🔹 Lưu tiến độ làm bài của người dùng
  Future<void> saveUserProgress(
      String userId,
      String quizId,
      String sectionId,
      SectionProgress progress,
      ) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(quizId)
        .set({
      sectionId: progress.toMap(),
    }, SetOptions(merge: true));
  }

  /// 🔹 Lấy tiến độ của người dùng trong 1 đề thi
  Future<Map<String, SectionProgress>> getUserProgress(
      String userId,
      String quizId,
      ) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(quizId)
        .get();

    if (!snapshot.exists) return {};

    final data = snapshot.data()!;
    return data.map((key, value) {
      return MapEntry(
        key,
        SectionProgress.fromMap(value),
      );
    });
  }
}
