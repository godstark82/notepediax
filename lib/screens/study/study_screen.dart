import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/screens/study/pages/user_courses.dart';
import 'package:course_app/screens/study/pages/user_notes.dart';
import 'package:course_app/screens/study/pages/user_quizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Study Center'),
          centerTitle: true,
        ),
        body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const UserCourses());
              },
              child: Container(
                  height: 150,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AssetImages.COURSES_SVG, height: 100),
                      SizedBox(height: 10),
                      Text(
                        'My Courses',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const UserQuizes());
              },
              child: Container(
                  height: 150,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AssetImages.QUIZES_SVG, height: 100),
                      SizedBox(height: 10),
                      Text(
                        'My Quizes',
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const UserNotes());
              },
              child: Container(
                  height: 150,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AssetImages.NOTES_SVG, height: 100),
                      SizedBox(height: 10),
                      Text(
                        'My Notes',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
