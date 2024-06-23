// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constants/db.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/non_state_var.dart';
import 'package:flutter/material.dart';

final admin = FirebaseFirestore.instance.collection('admin');

class CourseProvider extends ChangeNotifier {
  // variable for _courses in CourseModel
  List<Course> _courses = db.value['courses'] != null
      ? (db.value['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toSet()
          .toList()
      : [];

  List<Course> get courses => _courses;

  Future<bool> fetchCourses() async {
    try {
      _courses.clear();
      final query =
          await FirebaseFirestore.instance.collection('courses').get();
      final docs = query.docs;
      for (int i = 0; i < docs.length; i++) {
        final jsonString = docs[i].data();

        Course course = Course.fromJson(jsonString);

        _courses.add(course);
      }
      _courses.toSet().toList();
      _courses.sort((a, b) => a.creationTime.compareTo(b.creationTime));
      LocalVariables.allCourses = _courses;
      log('local var: ${LocalVariables.allCourses.length}');
      log('Course Fetched: ${courses.length}');

      notifyListeners();

      return true;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }
}
