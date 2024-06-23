import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({super.key, required this.course, required this.index});
  final Course course;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => Dialog(
                  // insetPadding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CachedNetworkImage(
                              imageUrl: course.teachers[index].img),
                        ),
                        Text(course.teachers[index].name),
                        Text('Subject: ${course.teachers[index].subject}'),
                        Text('Exp: ${course.teachers[index].experience} Years'),
                        const Divider(),
                        Text('About: ${course.teachers[index].desc}'),
                      ],
                    ),
                  ),
                ));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: context.width * 0.35,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: course.teachers[index].img)),
              ),
              Text(course.teachers[index].name),
              Text('Subject: ${course.teachers[index].subject}'),
              Text('Exp: ${course.teachers[index].experience} Years')
            ],
          ),
        ),
      ),
    );
  }
}
