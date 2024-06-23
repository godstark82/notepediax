import 'category_model.dart';

class StoreItemModel {
  String title;
  String image;
  double price;
  String description;
  Category category;
  String instaUrl;
  DateTime time;

  StoreItemModel(
      {required this.category,
      required this.instaUrl,
      required this.description,
      required this.image,
      required this.price,
      required this.time,
      required this.title});

  factory StoreItemModel.fromJson(Map<String, dynamic> json) {
    return StoreItemModel(
        instaUrl: json['instaUrl'],
        category: Category.fromJson(json['category']),
        description: json['description'] as String,
        image: json['image'] as String,
        price: double.parse(json['price'].toString()),
        time: DateTime.parse(json['time'].toString()),
        title: json['title'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'instaUrl': instaUrl,
      'title': title,
      'category': category.toJson(),
      'description': description,
      'image': image,
      'price': price,
      'time': time.toIso8601String()
    };
  }
}
