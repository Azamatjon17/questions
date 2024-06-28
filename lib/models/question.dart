import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String id;
  String question;
  List<dynamic> variants;
  int answer;

  Question({
    required this.id,
    required this.question,
    required this.variants,
    required this.answer,
  });

  factory Question.fromJson(QueryDocumentSnapshot query) {
    print("object");
    return Question(
      id: query.id,
      question: query['question'],
      variants: query['variants'],
      answer: query['answer'],
    );
  }
}
