// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/constants/styles/theme.dart';
import 'package:course_app/main.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/course/explore_course.dart';
import 'package:course_app/screens/home/home_screen.dart';
import 'package:course_app/screens/views/confirm_purchase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    // final isLightTheme = ThemeSwitcher.of(context).themeData == MyThemeData.lightTheme;
    final price = course.price;
    final oldPrice = course.price + ((course.price * course.discount) / 100);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 0),
                blurRadius: 2,
                color: Theme.of(context).cardColor,
                blurStyle: BlurStyle.inner),
            BoxShadow(
                offset: Offset(-1, 0),
                blurRadius: 2,
                color:Theme.of(context).cardColor,
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
              aspectRatio: 16 / 11,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: course.img.url,
                  width: context.width,
                  errorWidget: (context, error, _) {
                    return Icon(Icons.image);
                  },
                ),
              )),
          // Divider(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '$oldPrice',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(width: 10),
                  Text('Rs. $price /-',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith()),
                ],
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                  backgroundColor: Colors.deepPurple.shade600.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    //borderRadius: BorderRadius.zero, //Rectangular border
                  ),
                ),
                onPressed: () {
                  Get.to(() =>
                      ExploreCourseScreen(course: course, isPurchased: false));
                },
                child: Text('EXPLORE',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.white)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                  // backgroundColor: Colors.deepPurple.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    //borderRadius: BorderRadius.zero, //Rectangular border
                  ),
                ),
                onPressed: () async {
                  await Get.to(() => ConfirmCoursePurchasePage(course: course));
                  courses.clear();
                },
                child: const Text('BUY NOW'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
