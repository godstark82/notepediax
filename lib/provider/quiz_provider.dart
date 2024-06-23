import 'package:course_app/constants/db.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:course_app/provider/non_state_var.dart';
import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  final List<QuizModel> _quizes = ((db.value['quizes'] ?? []) as List)
      .map((quiz) => QuizModel.fromJson(quiz))
      .toList();

  List<QuizModel> get quizes => _quizes;

  void notify() {
    notifyListeners();
  }

  Future<bool> fetchQuizes() async {
    _quizes.clear();
    final collection = await admin.doc('db').collection('quizes').get();
    final docs = collection.docs;
    for (int i = 0; i < docs.length; i++) {
      _quizes.add(QuizModel.fromJson(docs[i].data()));
    }
    notifyListeners();
    _quizes.toSet().toList();
    _quizes.sort((a, b) => a.time.compareTo(b.time));
    LocalVariables.quizes = _quizes;
    return true;
  }
}
