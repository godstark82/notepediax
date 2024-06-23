import 'package:course_app/screens/home/components/all_courses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FilterViewHome extends StatelessWidget {
  const FilterViewHome(
      {super.key,
      required this.decreasingFn,
      required this.increasingFn,
      this.showHeader = false,
      this.sheetFunction,
      this.showSheet = false});

  final VoidCallback increasingFn;
  final VoidCallback decreasingFn;
  final bool showHeader;
  final bool showSheet;
  final VoidCallback? sheetFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Courses',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith()),
                    FilledButton(
                        onPressed: () {
                          Get.to(() => AllCoursesScreen());
                        },
                        child: Text('See more'))
                  ])),
        Row(
          children: [
            InkWell(
              onTap: sheetFunction,
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: const GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.red,
                        Colors.yellow
                      ]))),
                  child: Text('Filter')),
            ),
            Container(
              height: 30,
              width: 2,
              color: Colors.grey,
            ),
            const SizedBox(width: 16),
            RawChip(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                label: const Text('Latest'),
                onPressed: increasingFn),
            const SizedBox(width: 10),
            RawChip(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                label: const Text('Oldest'),
                onPressed: decreasingFn),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
