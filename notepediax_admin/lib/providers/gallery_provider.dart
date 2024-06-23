import 'dart:developer';

import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryProvider extends ChangeNotifier {
  final List<GalleryImage> _galleryImages = (db.value['gallery'] ?? [])
      .map((image) => GalleryImage.fromJson(image))
      .toList();

  List<GalleryImage> get gallery => _galleryImages;

  //
  Future<bool> fetchGallery() async {
    _galleryImages.clear();
    final coll = await admin.doc('db').collection('gallery').get();
    final docs = coll.docs;
    for (int i = 0; i < docs.length; i++) {
      _galleryImages.add(GalleryImage.fromJson(docs[i].data()));
    }

    _galleryImages.toSet().toList();

    log('Gallery Fetched: ${gallery.length}');
    notifyListeners();
    return true;
  }

  Future<String> uploadToStorage() async {
    String imgLink = '';
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    Reference reference =
        FirebaseStorage.instance.ref('images/${pickedFile!.path}');

    await reference
        .putData(await pickedFile.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'))
        .whenComplete(() async {
      await reference.getDownloadURL().then((value) => imgLink = value);
    });
    await admin.doc('db').collection('gallery').add({
      'url': imgLink,
      'ref': pickedFile.path,
    });
    _galleryImages.add(GalleryImage(url: imgLink, ref: pickedFile.path));
    notifyListeners();
    return imgLink;
  }

  Future<void> deleteImage(String ref) async {
    await FirebaseStorage.instance.ref('images/$ref').delete();
    _galleryImages.removeWhere((element) => element.ref == ref);
    final collection = await admin.doc('db').collection('gallery').get();
    collection.docs
        .firstWhere((element) => element.data()['ref'] == ref)
        .reference
        .delete();
    notifyListeners();
  }
}
