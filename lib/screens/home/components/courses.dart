import 'package:course_app/constants/widgets/course_tile.dart';
import 'package:course_app/constants/widgets/purchased_course_tile.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/home_screen.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenCourses extends StatelessWidget {
  const HomeScreenCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return courses.isNotEmpty
        ? SliverList.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              if (context
                  .watch<UserProvider>()
                  .userCourses
                  .contains(courses[index])) {
                return PurchasedCourseTile(course: courses[index]);
              } else {
                return CourseTile(course: courses[index]);
              }
            })
        : SliverToBoxAdapter(child: Center(child: EmptyWidget(
          hideBackgroundAnimation: true,
          packageImage: PackageImage.Image_1,
          title: 'No Courses Found',
        )));
  }
}
