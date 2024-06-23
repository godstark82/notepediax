import 'package:course_app/models/category_model.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/models/gallery_model.dart';

class NotesModel {
  String title;
  String description;
  Category category;
  GalleryImage image;
  double price;
  List<PDFModel> pdfs;
  DateTime time;

  NotesModel(
      {required this.title,
      required this.time,
      required this.category,
      required this.description,
      required this.pdfs,
      required this.image,
      required this.price});

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      time: DateTime.parse(json['time'].toString()),
      image: GalleryImage.fromJson(json['image']),
      title: json['title'],
      category: Category.fromJson(json['category']),
      description: json['description'],
      pdfs: (json['pdfs'] as List).map((e) => PDFModel.fromJson(e)).toList(),
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image.toJson(),
      'time': time.toIso8601String(),
      'category': category.toJson(),
      'description': description,
      'price': price,
      'pdfs': pdfs.map((e) => e.toJson())
    };
  }

  @override
  String toString() {
    return 'Title: $title, is a notes of category: $category of price: $price with total of ${pdfs.length} pdfs';
  }
}
