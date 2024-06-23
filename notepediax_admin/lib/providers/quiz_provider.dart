import 'dart:developer';

import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/quiz_model.dart';
import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  final List<QuizModel> _quizes = (db.value['quizes'] ?? [])
      .map((quiz) => QuizModel.fromJson(quiz))
      .toList();

  List<QuizModel> get quizes => _quizes;

  Future<bool> fetchQuizes() async {
    _quizes.clear();
    final coll = await admin.doc('db').collection('quizes').get();
    final docs = coll.docs;
    for (int i = 0; i < docs.length; i++) {
      _quizes.add(QuizModel.fromJson(docs[i].data()));
    }

    log('Quizes Fetched: ${quizes.length}');
    notifyListeners();
    return true;
  }

  Future<void> deleteQuiz(QuizModel quiz) async {
    _quizes.remove(quiz);
    final docs = await admin.doc('db').collection('quizes').get();
    for (int i = 0; i < docs.docs.length; i++) {
      if (docs.docs[i].data()['title'] == quiz.title) {
        await docs.docs[i].reference.delete();
      }
      notifyListeners();
    }
  }

  Future<void> saveQuizToFirestore(QuizModel quiz) async {
    _quizes.add(quiz);
    await admin.doc('db').collection('quizes').add(quiz.toJson());
    notifyListeners();
  }
}
