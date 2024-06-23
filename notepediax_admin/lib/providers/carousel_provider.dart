import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/carousel_model.dart';
import 'package:flutter/material.dart';

class CarouselProvider extends ChangeNotifier {
  final List<CarouselModel> _carousels = (db.value['carousel'] ?? [])
      .map((carousel) => CarouselModel.fromJson(carousel))
      .toList();

  List<CarouselModel> get carousels => _carousels;

  Future<List<CarouselModel>> fetchCarousel() async {
    _carousels.clear();
    final query = await admin.doc('db').collection('carousel').get();
    List<QueryDocumentSnapshot> docs = query.docs;
    for (int i = 0; i < docs.length; i++) {
      final jsonString = docs[i].data() as Map<String, dynamic>;
      final slider = CarouselModel.fromJson(jsonString);
      _carousels.add(slider);
    }
    notifyListeners();
    // ignore: unnecessary_null_comparison
    if (docs.isEmpty || docs == null) {
      return [];
    } else {
      return _carousels;
    }
  }

  Future<void> createCarousel(CarouselModel carousel) async {
    await admin.doc('db').collection('carousel').add(carousel.toJson());
    _carousels.add(carousel);
    notifyListeners();
  }

  Future<void> deleteCarousel(int index) async {
    final id = await admin.doc('db').collection('carousel').get();
    await id.docs[index].reference.delete();
    _carousels.removeAt(index);
    notifyListeners();
  }
}
