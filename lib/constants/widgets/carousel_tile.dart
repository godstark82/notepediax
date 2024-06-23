// ignore_for_file: avoid_unnecessary_containers

import 'package:course_app/models/carousel_model.dart';
import 'package:flutter/material.dart';

class CarouselTile extends StatelessWidget {
  const CarouselTile({super.key, required this.carousel});
  final CarouselModel carousel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: NetworkImage(carousel.image.url),
            height: 150,
            fit: BoxFit.fill,
          )),
    );
  }
}
