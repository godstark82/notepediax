import 'package:course_app/screens/quiz/components/user_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserQuizes extends StatefulWidget {
  const UserQuizes({super.key});

  @override
  State<UserQuizes> createState() => _UserQuizesState();
}

class _UserQuizesState extends State<UserQuizes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 150),
          child: Container(
            height: 160,
            decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.deepPurple,
                            size: 18,
                          )),
                        ))),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16),
                  child: Text(
                    'QUIZ',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
        body: UserQuizScreen());
  }
}
