import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/screens/course/explore_course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchasedCourseTile extends StatelessWidget {
  const PurchasedCourseTile({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final price = course.price;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4,sigmaY: 4),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.white),
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow:  [
                BoxShadow(
                    offset: Offset(1, 0),
                    blurRadius: 2,
                    color: Theme.of(context).cardColor,
                    blurStyle: BlurStyle.inner),
                BoxShadow(
                    offset: Offset(-1, 0),
                    blurRadius: 2,
                    color: Theme.of(context).cardColor,
                    blurStyle: BlurStyle.inner),
                // BoxShadow(offset: Offset.zero, blurRadius: 4,color: Colors.grey),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith()),
              SizedBox(height: 5),
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: course.img.url,
                      fit: BoxFit.cover,
                      // width: context.width,
                      errorWidget: (context, error, _) {
                        return Icon(Icons.image);
                      },
                    ),
                  )),
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rs. $price /-',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith()),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Discount of ${course.discount}% Applied',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                      )),
                ],
              ),
              SizedBox(height: 20),
              FilledButton(
                  onPressed: () {
                    Get.to(() => ExploreCourseScreen(
                        tabIndex: 1, course: course, isPurchased: true));
                  },
                  child: SizedBox(
                      width: context.width,
                      height: 50,
                      child: Center(child: Text('LET\'S STUDY'))))
            ],
          ),
        ),
      ),
    );
  }
}
