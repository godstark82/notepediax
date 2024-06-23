import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/components/filters.dart';
import 'package:course_app/screens/quiz/components/purchased_quiz_tile.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserQuizScreen extends StatefulWidget {
  const UserQuizScreen({super.key});

  @override
  State<UserQuizScreen> createState() => _UserQuizScreenState();
}

class _UserQuizScreenState extends State<UserQuizScreen> {
  List<QuizModel> quizes = [];

  void sortCoursesByDecreasedTime() {
    quizes.sort((a, b) => a.time.compareTo(b.time));
    setState(() {});
  }

  void sortCoursesByIncreasedTime() {
    quizes.sort((a, b) => b.time.compareTo(a.time));
    setState(() {});
  }

  @override
  void initState() {
    quizes = context.read<UserProvider>().userQuizes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizes.isEmpty
          ? Center(
              child: EmptyWidget(
              packageImage: PackageImage.Image_3,
              title: 'No Quizes Found',
              hideBackgroundAnimation: true,
              // subTitle: 'Try to add some quizes from HomeScreen',
            ))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: FilterViewHome(
                        showHeader: false,
                        decreasingFn: sortCoursesByDecreasedTime,
                        increasingFn: sortCoursesByIncreasedTime)),
                SliverList.builder(
                    itemCount: quizes.length,
                    itemBuilder: (context, index) {
                      return PurchasedQuizTile(quiz: quizes[index]);
                    })
              ],
            ),
    );
  }
}
