import 'package:course_app/main.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/quiz/components/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';

class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({super.key, required this.userQuiz});
  final QuizModel userQuiz;
  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<int?> selectedOptions = [];
  bool loading = false;
  int? selectedOption;
  GlobalKey<NavigatorState> dialogeNavigator = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: widget.userQuiz.questions.length, vsync: this);
    selectedOptions =
        List.generate(widget.userQuiz.questions.length, (index) => -1);
  }

  int calScore() {
    int currentScore = 0;
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == widget.userQuiz.questions[i].correctAnswer) {
        currentScore++;
      }
    }
    return currentScore;
  }

  void confirmExitfn(BuildContext context) async {
    await Get.dialog(
        AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Result will not be calculated if you go back without submit.'),
          actions: [
            TextButton(
                onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
                onPressed: () async {
                  navigatorKey.currentState?.pop();
                  Get.back();
                },
                child: const Text('Confirm Leave'))
          ],
        ),
        navigatorKey: dialogeNavigator);
  }

  @override
  Widget build(BuildContext context) {
    calScore();
    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        confirmExitfn(context);
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 0, 111, 202),
              Color.fromARGB(255, 0, 142, 203),
              Color.fromARGB(255, 0, 177, 221)
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                      onPressed: () async {
                        if (selectedOptions.contains(null) == false) {
                          loading = true;
                          setState(() {});
                          //
                          // code to update the data on firestore'
                          int score = calScore();

                          final newQuiz = widget.userQuiz.copyWith(
                            lastScore: score,
                            isAttempted: true,
                            isPurchased: true,
                            lastResponse: selectedOptions,
                          );

                          await context
                              .read<UserProvider>()
                              .updateQuiz(newQuiz);
                          loading = false;
                          setState(() {});
                          // navigate to other screen
                          Get.off(() => QuizResultScreen(userQuiz: newQuiz));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please Select atleast one option')));
                        }
                      },
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('SUBMIT')),
                ),
              ],
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    confirmExitfn(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white)),
              backgroundColor: Colors.transparent,
              title: Text(widget.userQuiz.title),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: widget.userQuiz.questions.map((question) {
                RadioGroupController radioGroupController =
                    RadioGroupController();
                final index = widget.userQuiz.questions.indexOf(question);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text("Q${index + 1}"),
                        Center(child: Text(question.question)),
                        const SizedBox(height: 35),
                        RadioGroup(
                          controller: radioGroupController,
                          values: question.options,
                          indexOfDefault: selectedOptions[index]! - 1,
                          labelBuilder: (label) {
                            return Card(
                              margin: const EdgeInsets.all(10),
                              color: Colors.blue.withOpacity(0.1),
                              child: CupertinoListTile(
                                  padding: const EdgeInsets.all(8),
                                  title: Text(
                                    label,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            );
                          },
                          decoration: const RadioGroupDecoration(
                            fillColor: WidgetStatePropertyAll(Colors.orange),
                            spacing: 15,
                          ),
                          onChanged: (newvalue) {
                            selectedOption =
                                question.options.indexOf(newvalue) + 1;
                            selectedOptions[index] = selectedOption;
                          },
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tabController.index == 0
                                ? const SizedBox()
                                : FilledButton(
                                    onPressed: () {
                                      tabController
                                          .animateTo(tabController.index - 1);
                                      setState(() {});
                                    },
                                    child: const Text('Back')),
                            if (tabController.index + 1 !=
                                widget.userQuiz.questions.length)
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: FilledButton(
                                    onPressed: () {
                                      if (selectedOptions[index] != null) {
                                        tabController
                                            .animateTo(tabController.index + 1);
                                        setState(() {});
                                      }
                                    },
                                    child: const Text('Next')),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }
}
