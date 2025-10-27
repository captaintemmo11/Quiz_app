import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';
import '../models/section_model.dart';
import '../models/question_model.dart';
import '../models/user_progress_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Quiz>> getAllQuizzes() async {
    final quizSnapshot = await _db.collection('quizzes').get();
    List<Quiz> quizzes = [];

    for (var doc in quizSnapshot.docs) {
      final sections = await getSections(doc.id);
      quizzes.add(
        Quiz.fromMap(doc.data(), doc.id, sections),
      );
    }

    return quizzes;
  }

  Future<List<Section>> getSections(String quizId) async {
    final sectionSnapshot =
    await _db.collection('quizzes').doc(quizId).collection('sections').orderBy('order').get();
    List<Section> sections = [];

    for (var sec in sectionSnapshot.docs) {
      final questions = await getQuestions(quizId, sec.id);
      sections.add(
        Section.fromMap(sec.data(), sec.id, questions),
      );
    }

    return sections;
  }

  Future<List<Question>> getQuestions(String quizId, String sectionId) async {
    final questionSnapshot = await _db
        .collection('quizzes')
        .doc(quizId)
        .collection('sections')
        .doc(sectionId)
        .collection('questions')
        .get();

    return questionSnapshot.docs
        .map((doc) => Question.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> saveUserProgress(
      String userId, String quizId, String sectionId, SectionProgress progress) async {
    await _db
        .collection('user_progress')
        .doc(userId)
        .collection('quizzes')
        .doc(quizId)
        .set({
      'sections.$sectionId': progress.toMap(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, SectionProgress>> getUserProgress(
      String userId, String quizId) async {
    final doc =
    await _db.collection('user_progress').doc(userId).collection('quizzes').doc(quizId).get();

    if (!doc.exists) return {};

    final data = doc.data()!;
    final sections = (data['sections'] ?? {}) as Map<String, dynamic>;

    return sections.map((key, value) =>
        MapEntry(key, SectionProgress.fromMap(value as Map<String, dynamic>)));
  }
}
