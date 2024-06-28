import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson66/models/question.dart';

class QustionService {
  final _productCollection = FirebaseFirestore.instance.collection("questions");

  Stream<QuerySnapshot> getQuestion() async* {
    yield* _productCollection.snapshots();
  }

  void addQuestion(Question question) {
    _productCollection.add({
      'answer': question.answer,
      'question': question.question,
      'variants,': question.variants,
    });
  }

  void editQuestion(Question question) {
    _productCollection.doc(question.id).update({
      'answer': question.answer,
      'question': question.question,
      'variants,': question.variants,
    });
  }

  void deleteQuestion(String id) {
    _productCollection.doc(id).delete();
  }
}
