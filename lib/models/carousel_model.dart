import 'package:course_app/models/course_model.dart';
import 'package:course_app/models/gallery_model.dart';

class CarouselModel {
  final GalleryImage image;
  final Course course;
  final String carouselTitle;

  CarouselModel({
    required this.course,
    required this.carouselTitle,
    required this.image,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
        course: Course.fromJson(json['course']),
        carouselTitle: json['carouselTitle'],
        image: GalleryImage.fromJson(json['image']));
  }

  Map<String, dynamic> toJson() {
    return {
      'carouselTitle': carouselTitle,
      'course': course.toJson(),
      'image': image.toJson(),
    };
  }
}