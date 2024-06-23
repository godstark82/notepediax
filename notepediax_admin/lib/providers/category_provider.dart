import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  // variable for categories in Category Model
  final List<Category> _categories = (db.value['category'] ?? [])
      .map((category) => Category.fromJson(category))
      .toList();
  List<Category> get categories => _categories;

  Future<bool> fetchCategories() async {
    _categories.clear();
    final query = await admin.doc('db').collection('category').get();
    List<QueryDocumentSnapshot> docs = query.docs;
    for (int i = 0; i < docs.length; i++) {
      final jsonString = docs[i].data() as Map<String, dynamic>;
      final category = Category.fromJson(jsonString);
      _categories.add(category);
    }
    log('Category Fetched: ${categories.length}');
    notifyListeners();
    return true;
  }

  // fn for creating category
  Future<void> createCategory(Category category) async {
    await admin.doc('db').collection('category').add(category.toJson());
    _categories.add(category);
    notifyListeners();
  }
  //
  // fn end

  //
  // fn for deleting a category
  Future<void> deleteCategory(int index) async {
    final idData = await admin.doc('db').collection('category').get();
    await idData.docs[index].reference.delete();
    _categories.removeAt(index);
    notifyListeners();
  }
}
