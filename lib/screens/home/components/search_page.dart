import 'package:course_app/constants/widgets/course_tile.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String query = '';
  List<Course> filteredCourses = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back)),
              SizedBox(
                width: context.width * 0.8,
                child: TextFormField(
                  autofocus: true,
                  onChanged: (value) {
                    query = value;
                  },
                  decoration: const InputDecoration().copyWith(
                      hintText: 'Search here...',
                      suffixIcon: Icon(Icons.search)),
                  onFieldSubmitted: (value) {
                    filteredCourses.clear();
                    final courses = context.read<CourseProvider>().courses;
                    for (int i = 0; i < courses.length; i++) {
                      if (courses[i]
                          .title
                          .isCaseInsensitiveContainsAny(value)) {
                        filteredCourses.add(courses[i]);
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        body: filteredCourses.isEmpty
            ? Text("No Data Found")
            : ListView.builder(
                itemCount: filteredCourses.length,
                itemBuilder: (context, idx) {
                  return CourseTile(course: filteredCourses[idx]);
                }),
      ),
    );
  }
}
