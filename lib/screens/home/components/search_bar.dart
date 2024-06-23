// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:course_app/screens/home/components/search_page.dart';
import 'package:course_app/screens/study/study_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SearchBarHomeScreen extends StatelessWidget {
  const SearchBarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Get.to(() => SearchResultPage());
            },
            child: Container(
              height: 50,
              width: context.width * 0.70,
              decoration: BoxDecoration(
                  border: GradientBoxBorder(gradient: LinearGradient(colors: [Colors.blue,Colors.red,Colors.yellow,Colors.green])),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 20),
                    Text('Search for \'batches\'...')
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => StudyScreen());
            },
            child: Container(
              height: 50,
              width: context.width * 0.20,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text('Study', style: TextStyle(color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }
}
