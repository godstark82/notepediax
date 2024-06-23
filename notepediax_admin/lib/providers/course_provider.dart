import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  // variable for _courses in CourseModel
  final List<Course> _courses = (db.value['courses'] ?? [])
      .map((course) => Course.fromJson(course))
      .toList();

  List<Course> get courses => _courses.toSet().toList();

  Future<bool> fetchCourses() async {
    _courses.clear();
    final query = await FirebaseFirestore.instance.collection('courses').get();
    final docs = query.docs;
    for (int i = 0; i < docs.length; i++) {
      final jsonString = docs[i].data();

      Course course = Course.fromJson(jsonString);

      _courses.add(course);
    }
    _courses.toSet().toList();
    _courses.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    notifyListeners();

    return true;
  }

  Future<void> createCourse(Course course) async {
    await FirebaseFirestore.instance.collection('courses').add(course.toJson());
    _courses.add(course);
    notifyListeners();
  }

  Future<void> updateCourse(Course course, int index) async {
    final title = await FirebaseFirestore.instance.collection('courses').get();
    title.docs
        .firstWhere((element) => element.data()['id'] == course.id)
        .reference
        .update(course.toJson());
    final myCourse = course;
    _courses.removeAt(index);
    _courses.insert(index, myCourse);
    notifyListeners();
  }

  Future<void> updateSubject(
    Subject subject,
    int courseIndex,
    int subjectIndex,
  ) async {
    courses[courseIndex].subjects[subjectIndex] = subject;
    final title = await FirebaseFirestore.instance.collection('courses').get();
    final oldSubjects =
        (title.docs.elementAt(courseIndex).data()['subjects'] as List);
    oldSubjects.removeAt(subjectIndex);
    oldSubjects.insert(subjectIndex, subject.toJson());
    await title.docs.elementAt(courseIndex).reference.update({
      'subjects': oldSubjects,
    });
    final mySubject = subject;
    courses[courseIndex].subjects.removeAt(subjectIndex);
    courses[courseIndex].subjects.insert(subjectIndex, mySubject);
    notifyListeners();
  }

  Future<void> updateChapter(
    Chapter chapter,
    int courseIndex,
    int subjectIndex,
    int chapterIndex,
  ) async {
    final mychapter = chapter;
    (courses[courseIndex].subjects[subjectIndex].chapters ?? [])
        .removeAt(chapterIndex);
    (courses[courseIndex].subjects[subjectIndex].chapters ?? [])
        .insert(chapterIndex, mychapter);
    final mySubject = Subject(
        name: courses[courseIndex].subjects[subjectIndex].name,
        image: courses[courseIndex].subjects[subjectIndex].image,
        chapters: courses[courseIndex].subjects[subjectIndex].chapters);
    await updateSubject(mySubject, courseIndex, subjectIndex);

    notifyListeners();
  }

  Future<void> deleteCourse(int index) async {
    final docs = await FirebaseFirestore.instance.collection('courses').get();
    await docs.docs[index].reference.delete();
    _courses.removeAt(index);
    notifyListeners();
  }
}
