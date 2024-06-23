import 'package:course_app/constants/widgets/course_tile.dart';
import 'package:course_app/constants/widgets/purchased_course_tile.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/components/filters.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key});
  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  List<Course> courses = [];

  @override
  void initState() {
    courses = context.read<CourseProvider>().courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('All Courses'),
          centerTitle: true,
        ),
        body: courses.isEmpty
            ? Center(
              child: EmptyWidget(
                  hideBackgroundAnimation: true,
                  packageImage: PackageImage.Image_2,
                  title: 'No Courses',
                ),
            )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FilterViewHome(
                      decreasingFn: () {
                        courses.sort(
                            (a, b) => b.creationTime.compareTo(a.creationTime));
                        setState(() {});
                      },
                      increasingFn: () {
                        courses.sort(
                            (a, b) => a.creationTime.compareTo(b.creationTime));
                        setState(() {});
                      },
                    ),
                  ),
                  SliverList.builder(
                    itemCount: context.read<CourseProvider>().courses.length,
                    itemBuilder: (context, index) {
                      if (context.read<UserProvider>().userCourses.contains(
                          context.read<CourseProvider>().courses[index])) {
                        return PurchasedCourseTile(
                            course:
                                context.read<CourseProvider>().courses[index]);
                      } else {
                        return CourseTile(
                          course: context.read<CourseProvider>().courses[index],
                        );
                      }
                    },
                  )
                ],
              ));
  }
}
