import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/carousel_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/course/explore_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreenCarousel extends StatelessWidget {
  const HomeScreenCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final carousels = context.read<CarouselProvider>().carousels;
    return FlutterCarousel.builder(
      options: CarouselOptions(
          showIndicator: true,
          aspectRatio: 16 / 9,
          floatingIndicator: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          pageSnapping: false,
          slideIndicator: CircularSlideIndicator(
              currentIndicatorColor: Colors.white,
              indicatorBorderColor: Colors.grey.shade300),
          enableInfiniteScroll: true),
      itemCount: carousels.length,
      itemBuilder: (context, index, u) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
              onTap: () {
                Get.to(() => ExploreCourseScreen(
                      course: Course.fromId(carousels[index].course.id),
                      isPurchased: context
                              .read<UserProvider>()
                              .userCourses
                              .firstWhereOrNull((element) =>
                                  element.id == carousels[index].course.id) !=
                          null,
                    ));
              },
              child: carousels.isEmpty
                  ? const SizedBox()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: carousels[index].image.url,
                        fit: BoxFit.fill,
                      ))),
        );
      },
    );
  }
}
