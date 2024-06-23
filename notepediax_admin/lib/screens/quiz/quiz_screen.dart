import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/models/quiz_model.dart';
import 'package:course_admin/providers/quiz_provider.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quizes'),
          actions: [
            FilledButton.icon(
                onPressed: () {
                  Get.to(() => const AddQuizScreen());
                },
                icon: const Icon(Icons.add),
                label: const Text('New Quiz'))
          ],
        ),
        body: FutureBuilder(
            future: context.read<QuizProvider>().fetchQuizes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return context.watch<QuizProvider>().quizes.isEmpty
                    ? Center(
                        child: EmptyWidget(
                          title: 'No Quizes Created',
                          packageImage: PackageImage.Image_4,
                          hideBackgroundAnimation: true,
                        ),
                      )
                    : ListView.builder(
                        itemCount: context.read<QuizProvider>().quizes.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: CupertinoListTile(
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          final quiz = context
                                              .read<QuizProvider>()
                                              .quizes[index];
                                          return AlertDialog(
                                            title: Text(quiz.title),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (quiz.image!.isNotEmpty)
                                                  Image.network(
                                                      quiz.image.toString()),
                                                Text(quiz.description),
                                                Text('Price: ${quiz.price}'),
                                                Text(
                                                    'Total Questions: ${quiz.questions.length}'),
                                                const SizedBox(height: 10),
                                                Column(
                                                  children: quiz.questions
                                                      .map((e) => Card(
                                                            child: ListTile(
                                                              isThreeLine: true,
                                                              title: Text(
                                                                  e.question),
                                                              subtitle: Text(e
                                                                  .options
                                                                  .toString()),
                                                              trailing: Text(
                                                                  'Correct Option: ${e.correctAnswer}'),
                                                            ),
                                                          ))
                                                      .toList(),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text('Close'))
                                            ],
                                          );
                                        });
                                  },
                                  title: Text(context
                                      .read<QuizProvider>()
                                      .quizes[index]
                                      .title),
                                  leading: Text('${index + 1}'),
                                  trailing: IconButton(
                                    iconSize: 24,
                                    onPressed: () {
                                      context.read<QuizProvider>().deleteQuiz(
                                          context
                                              .read<QuizProvider>()
                                              .quizes[index]);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                  subtitle: Text(
                                      'Questions: ${context.read<QuizProvider>().quizes[index].questions.length}')));
                        });
              }
            }));
  }
}

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String quizName = '';
  List<QuizQuestion> questions = [];
  String image = '';
  double? price;
  String description = '';
  String quizImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
        actions: [
          FilledButton.icon(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  context.read<QuizProvider>().saveQuizToFirestore(QuizModel(
                      description: description,
                      image: quizImage,
                      price: price!,
                      isPurchased: false,
                      title: quizName,
                      time: DateTime.now(),
                      questions: questions));
                  Get.back();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Quiz')),
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.width * 0.3, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    onChanged: (value) {
                      quizName = value;
                    },
                    fieldName: 'Quiz Name'),
                const Gap(10),
                CustomTextField(
                    onChanged: (value) {
                      description = value;
                    },
                    fieldName: 'Description'),
                const Gap(10),
                CustomTextField(
                    onChanged: (value) {
                      price = double.parse(value);
                    },
                    fieldName: 'Price'),
                const Gap(10),
                if (quizImage == '')
                  FilledButton.icon(
                      onPressed: () async {
                        await chooseIMGFun(context)
                            .then((value) => quizImage = value.url);
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add Image')),
                if (quizImage != '') Image.network(quizImage, height: 120),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Questions'),
                    FilledButton(
                        onPressed: () {
                          String question = '';
                          String option1 = '';
                          String option2 = '';
                          String option3 = '';
                          String option4 = '';
                          int correctOption = 0;
                          showDialog(
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, ststate) {
                              return AlertDialog(
                                title: const Text('Add Question'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (image == '')
                                      FilledButton(
                                          onPressed: () async {
                                            await chooseIMGFun(context).then(
                                                (value) => image = value.url);
                                            ststate(() {});
                                          },
                                          child: const Text('Image')),
                                    if (image != '')
                                      Image.network(image, height: 100),
                                    CustomTextField(
                                        onChanged: (value) {
                                          question = value;
                                        },
                                        fieldName: 'Question'),
                                    CustomTextField(
                                        onChanged: (value) {
                                          option1 = value;
                                        },
                                        fieldName: 'Option 1'),
                                    CustomTextField(
                                        onChanged: (value) {
                                          option2 = value;
                                        },
                                        fieldName: 'Option 1'),
                                    CustomTextField(
                                        onChanged: (value) {
                                          option3 = value;
                                        },
                                        fieldName: 'Option 1'),
                                    CustomTextField(
                                        onChanged: (value) {
                                          option4 = value;
                                        },
                                        fieldName: 'Option 1'),
                                    CustomTextField(
                                        onChanged: (value) {
                                          correctOption = int.parse(value);
                                        },
                                        fieldName: 'Correct Option'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        questions.add(QuizQuestion(
                                            image: image,
                                            question: question,
                                            options: [
                                              option1,
                                              option2,
                                              option3,
                                              option4
                                            ],
                                            correctAnswer: correctOption));
                                        setState(() {});
                                        image = '';
                                        Get.back();
                                      },
                                      child: const Text('Add'))
                                ],
                              );
                            }),
                          );
                        },
                        child: const Text('New Question'))
                  ],
                ),
                const Gap(10),
                if (questions.isNotEmpty)
                  ListView.builder(
                      itemCount: questions.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(questions[index].question),
                          subtitle: Text(
                              'Correct Option: ${questions[index].correctAnswer}'),
                          children: questions[index]
                              .options
                              .map((option) => Text(option))
                              .toList(),
                        );
                      })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewQuizDetails extends StatelessWidget {
  const ViewQuizDetails({super.key, required this.quizModel});
  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quizModel.title)),
      body: const Column(),
    );
  }
}
