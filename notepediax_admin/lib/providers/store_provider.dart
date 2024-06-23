import 'dart:developer';

import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/store_item_model.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  final List<StoreItemModel> _storeItems = (db.value['store'] ?? [])
      .map((storeItem) => StoreItemModel.fromJson(storeItem))
      .toList();

  List<StoreItemModel> get storeItems => _storeItems;

  Future<bool> fetchStore() async {
    _storeItems.clear();
    final coll = await admin.doc('db').collection('store').get();
    final docs = coll.docs;
    for (int i = 0; i < docs.length; i++) {
      _storeItems.add(StoreItemModel.fromJson(docs[i].data()));
    }

    log('StoreItems Fetched: ${storeItems.length}');
    notifyListeners();
    return true;
  }

  Future<void> addNewStoreItem(StoreItemModel storeItem) async {
    _storeItems.add(storeItem);
    await admin.doc('db').collection('store').add(storeItem.toJson());
    notifyListeners();
  }

  Future<void> deleteItem(int index, StoreItemModel storeItem) async {
    try {
      _storeItems.removeAt(index);
      final collection = await admin.doc('db').collection('store').get();
      for (int i = 0; i < collection.docs.length; i++) {
        if (collection.docs[i].data()['title'] == storeItem.title) {
          await collection.docs[i].reference.delete();
        }
      }
      log('StoreItem deleted');
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
