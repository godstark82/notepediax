// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constants/db.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/models/notes_model.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:course_app/provider/notes_provider.dart';
import 'package:course_app/provider/quiz_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  List<Course> _userCourses = db.value['user-courses'] != null
      ? (db.value['user-courses'] as List)
          .map((course) => Course.fromJson(course))
          .toSet()
          .toList()
      : [];

  List<Course> get userCourses => _userCourses;

  // func for adding a course in this list
  Future<void> buyCourse(Course course) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('courses')
        .add({'id': course.id});
    _userCourses.add(course);
    notifyListeners();
  }

  Future<bool> fetchUserCourses(BuildContext context) async {
    _userCourses.clear();
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('courses')
        .get();
    await context.read<CourseProvider>().fetchCourses();
    final docs = query.docs;
    for (int i = 0; i < docs.length; i++) {
      final jsonString = docs[i].data();
      for (var j = 0; j < context.read<CourseProvider>().courses.length; j++) {
        if (jsonString['id'] == context.read<CourseProvider>().courses[j].id) {
          _userCourses.add(context.read<CourseProvider>().courses[j]);
        }
      }
    }

    _userCourses.toSet().toList();
    _userCourses.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    log('User Courses Fetched: ${_userCourses.length}');
    notifyListeners();

    return true;
  }

  //
  // for Notes
  List<NotesModel> _userNotes = db.value['user-notes'] != null
      ? (db.value['user-notes'] as List)
          .map((note) => NotesModel.fromJson(note))
          .toSet()
          .toList()
      : [];

  List<NotesModel> get userNotes => _userNotes;

  // func for adding a course in this list
  Future<void> buyNotes(NotesModel notes) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .add({'title': notes.title});
    _userNotes.add(notes);
    notifyListeners();
  }

  Future<bool> fetchUserNotes(BuildContext context) async {
    try {
      _userNotes.clear();
      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notes')
          .get();
      await context.read<NotesProvider>().fetchNotes();
      final docs = query.docs;
      for (int i = 0; i < docs.length; i++) {
        final jsonString = docs[i].data();
        for (var j = 0; j < context.read<NotesProvider>().notes.length; j++) {
          if (jsonString['title'] ==
              context.read<NotesProvider>().notes[j].title) {
            _userNotes.add(context.read<NotesProvider>().notes[j]);
          }
        }
      }

      _userNotes.toSet().toList();
      _userNotes.sort((a, b) => a.time.compareTo(b.time));
      log('User Notes Fetched: ${_userCourses.length}');
      notifyListeners();
    } catch (e) {
      Get.printError(info: e.toString());
    }
    return true;
  }

  // for Quiz
  List<QuizModel> _userQuiz = db.value['user-quiz'] != null
      ? (db.value['user-quiz'] as List)
          .map((note) => QuizModel.fromJson(note))
          .toSet()
          .toList()
      : [];

  List<QuizModel> get userQuizes => _userQuiz;

  // func for adding a course in this list
  Future<void> buyQuizes(QuizModel quiz) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('quizes')
        .add({'title': quiz.title});
    _userQuiz.add(quiz);
    notifyListeners();
  }

  bool checkQuizPurchased(BuildContext context, QuizModel quiz) {
    bool isPurchased = false;
    final userQuiz = context.read<UserProvider>().userQuizes;
    for (var i = 0; i < userQuiz.length; i++) {
      if (userQuiz[i].title == quiz.title) {
        isPurchased = true;
      }
    }
    return isPurchased;
  }

  Future<bool> fetchUserQuizes(BuildContext context) async {
    try {
      _userQuiz.clear();
      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('quizes')
          .get();
      await context.read<QuizProvider>().fetchQuizes();
      final docs = query.docs;
      for (int i = 0; i < docs.length; i++) {
        final jsonString = docs[i].data();
        for (var j = 0; j < context.read<QuizProvider>().quizes.length; j++) {
          if (jsonString['title'] ==
              context.read<QuizProvider>().quizes[j].title) {
            _userQuiz.add(QuizModel.fromJson(jsonString));
          }
        }
      }
      _userQuiz.toSet().toList();
      _userQuiz.sort((a, b) => a.time.compareTo(b.time));

      log('User Quizes Fetched: ${_userCourses.length}');
      notifyListeners();
    } catch (e) {
      Get.printError(info: e.toString());
    }
    return true;
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    final index =
        _userQuiz.indexWhere((element) => element.title == quiz.title);
    _userQuiz[index] = quiz;
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('quizes')
        .get();
    final docs = collection.docs;

    final refDocument =
        docs.firstWhere((element) => element.data()['title'] == quiz.title);
    await refDocument.reference.update(quiz.toJson());
    notifyListeners();
  }
}
