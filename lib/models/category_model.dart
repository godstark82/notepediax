class Category {
  final String? name;
  final String? img;

  Category({this.img, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }
}
