import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Quiz>> getQuizzes() {
    return _db.collection('quizzes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Quiz.fromMap(doc.data(), doc.id)).toList());
  }
}
