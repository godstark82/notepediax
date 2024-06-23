// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constants/db.dart';
import 'package:course_app/models/category_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  // variable for categories in Category Model
  List<Category> _categories = db.value['category'] != null
      ? (db.value['category'] ?? [])
          .map((category) => Category.fromJson(category))
          .toList()
      : [];
  List<Category> get categories => _categories;

  Future<List<Category>> fetchCategories() async {
    try {
      _categories.clear();
      final query = await admin.doc('db').collection('category').get();
      List<QueryDocumentSnapshot> docs = query.docs;
      for (int i = 0; i < docs.length; i++) {
        final jsonString = docs[i].data() as Map<String, dynamic>;
        final category = Category.fromJson(jsonString);
        _categories.add(category);
      }
      log('Category Fetched ${categories.length}');
      notifyListeners();
      return _categories;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
