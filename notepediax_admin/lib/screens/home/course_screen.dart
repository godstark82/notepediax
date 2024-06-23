import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/screens/home/components/ADD/add_course.dart';
import 'package:course_admin/screens/home/components/ADD/add_subject.dart';
import 'package:course_admin/screens/home/components/VIEW/view_course.dart';
import 'package:course_admin/screens/home/components/global_vars.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Courses'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
                onPressed: () {
                  // AddCourseVariables.clear();
                  if (context.read<CategoryProvider>().categories.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                'Warning!!!',
                                style: TextStyle(color: Colors.red),
                              ),
                              content: const Text(
                                  'Have you created categories & uploaded images related to your course before proceeding? \n You should create cateogory & upload images related to this course before proceeding.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Back')),
                              ],
                            ));
                  } else {
                    Get.back();
                    clearTempCourse();
                    chapters.clear();
                    Get.to(() => const AddCourseScreen());
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Create new course')),
          )
        ],
      ),
      // fetching gallery first
      body: FutureBuilder(
        future: context.read<CourseProvider>().fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return context.watch<CourseProvider>().courses.isEmpty
                ? Center(
                    child: EmptyWidget(
                    title: 'No Courses Created',
                    packageImage: PackageImage.Image_3,
                    hideBackgroundAnimation: true,
                  ))
                : ListView.builder(
                    itemCount: context.watch<CourseProvider>().courses.length,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(() => ViewCourseScreen(index: index));
                            },
                            leading: context
                                    .read<CourseProvider>()
                                    .courses[index]
                                    .img
                                    .url
                                    .isNotEmpty
                                ? Image.network(context
                                    .read<CourseProvider>()
                                    .courses[index]
                                    .img
                                    .url)
                                : const Text('No Image'),
                            title: Text(context
                                .read<CourseProvider>()
                                .courses[index]
                                .title),
                            subtitle: Text(context
                                .read<CourseProvider>()
                                .courses[index]
                                .description),
                            isThreeLine: true,
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'Delete') {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                                'Are you sure you want to delete this course. This action is irreversible.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    // await value.deleteCourse(index);
                                                    // Get.back();
                                                    await context
                                                        .read<CourseProvider>()
                                                        .deleteCourse(index);
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    'DELETE',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          ));
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'Delete',
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  )
                                ];
                              },
                            ),
                          ),
                        ));
            // : ResponsiveGridList(
            //     minItemWidth: 300,
            //     children: context
            //         .read<CourseProvider>()
            //         .courses
            //         .map((course) => CourseCard(course: course))
            //         .toList());
          }
        },
      ),
    );
  }
}
