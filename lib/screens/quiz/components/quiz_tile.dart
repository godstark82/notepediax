import 'package:course_app/constants/styles/theme.dart';
import 'package:course_app/main.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/quiz_provider.dart';
import 'package:course_app/screens/quiz/components/enroll_quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class QuizTile extends StatelessWidget {
  const QuizTile({super.key, required this.quiz});
  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ThemeSwitcher.of(context).themeData == MyThemeData.darkTheme;
    List<Color> bgColors = [
      Colors.blue.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.green.shade100
    ];
    Color color = (bgColors..shuffle()).first;
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.swatch.shade300, width: 2)),
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: isDarkTheme ?color.swatch.shade900 : color,
          onTap: () {
            //enroll
            Get.to(() => EnrollQuizScreen(quiz: quiz));
          },
          // backgroundColor: (bgColors..shuffle()).first,
          leading: CircleAvatar(
            backgroundColor:  isDarkTheme ?color : color.swatch.shade400,
            child: Text(
                '${context.read<QuizProvider>().quizes.indexOf(quiz) + 1}',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          trailing: const Icon(Icons.start, color: Colors.blueAccent),
          subtitle: Text('Questions: ${quiz.questions.length}'),
          title: Text(
            quiz.title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          )),
    );
  }
}
