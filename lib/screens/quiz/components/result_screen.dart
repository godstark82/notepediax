import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/screens/quiz/components/play_quiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key, required this.userQuiz});
  final QuizModel userQuiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 13, 19, 87),
        Color.fromARGB(255, 15, 25, 98),
        Color.fromARGB(255, 16, 29, 105)
      ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // leading: IconButton(onPressed: (), icon: icon),
          title: const Text('Quiz Result',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SizedBox(
          height: context.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                  child: Lottie.asset(LottieFiles.RESULT,
                      height: 200, width: 200)),
              const SizedBox(height: 15),
              const Text('Congratulations',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 10),
              const Text('You have completed the quiz and here is the result',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 30),
              Text('Y O U R  S C O R E',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${userQuiz.lastScore} ',
                      style:
                          TextStyle(fontSize: 32, color: Colors.teal.shade200)),
                  Text('/ ${userQuiz.questions.length}',
                      style: const TextStyle(fontSize: 32, color: Colors.white))
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          height: 150,
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton.icon(
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back')),
              FilledButton.icon(
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  onPressed: () {
                    Get.off(() => PlayQuizScreen(userQuiz: userQuiz));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry')),
              FilledButton.icon(
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  onPressed: () {
                    VxBottomSheet.bottomSheetView(context,
                        roundedFromTop: false,
                        child: SizedBox(
                          height: 500,
                          child: ListView(
                            shrinkWrap: true,
                            children: userQuiz.questions.map((question) {
                              final index =
                                  userQuiz.questions.indexOf(question);
                              return CupertinoListTile(
                                trailing: question.correctAnswer ==
                                        userQuiz.lastResponse![index]!
                                    ? const Text('+1').text.green900.make()
                                    : const Text('-1').text.red500.make(),
                                subtitle: Text(
                                    'Correct Answer: ${question.options[question.correctAnswer - 1]}'),
                                additionalInfo: Text(
                                    'You marked: ${question.options[userQuiz.lastResponse![index]! - 1]}'),
                                title: Text(question.question),
                                leading: question.correctAnswer ==
                                        userQuiz.lastResponse![index]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const Icon(Icons.close,
                                        color: Colors.red),
                              );
                            }).toList(),
                          ),
                        ));
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('Details'))
            ],
          ),
        ),
      ),
    );
  }
}
