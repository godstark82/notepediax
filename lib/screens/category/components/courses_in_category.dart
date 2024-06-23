import 'package:course_app/constants/widgets/course_tile.dart';
import 'package:course_app/models/category_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:course_app/screens/home/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCourses extends StatefulWidget {
  const CategoryCourses({super.key, required this.cateogry});
  final Category cateogry;

  @override
  State<CategoryCourses> createState() => _CategoryCoursesState();
}

class _CategoryCoursesState extends State<CategoryCourses> {
  @override
  Widget build(BuildContext context) {
    final courses = context
        .watch<CourseProvider>()
        .courses
        .where((element) => element.category.name == widget.cateogry.name)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cateogry.name} Courses"),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50), child: SearchBarHomeScreen()),
      ),
      body: courses.isEmpty
          ? Center(child: Text("No Courses Found in this category"))
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseTile(course: courses[index]);
              }),
    );
  }
}
