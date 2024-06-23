// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:collection';
import 'dart:developer';

import 'package:course_app/constants/db.dart';
import 'package:course_app/models/carousel_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:flutter/material.dart';

class CarouselProvider extends ChangeNotifier {
  List<CarouselModel> _carousels = db.value['carousel'] != null
      ? (db.value['carousel'] ?? [])
          .map((carousel) => CarouselModel.fromJson(carousel))
          .toList()
      : [];

  List<CarouselModel> get carousels => _carousels.toSet().toList();

  Future<List<CarouselModel>> fetchCarousel() async {
    _carousels.clear();
    final query = await admin.doc('db').collection('carousel').get();
    final docs = query.docs;
    for (int i = 0; i < docs.length; i++) {
      final jsonString = docs[i].data();

      CarouselModel carouselModel = CarouselModel.fromJson(jsonString);
      _carousels.add(carouselModel);
    }
    log('Carousel Fetched ${carousels.length}');
    final fetchedCarousels =
        LinkedHashSet<CarouselModel>.from(_carousels).toList();
    notifyListeners();

    return fetchedCarousels;
  }
}
