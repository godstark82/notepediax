import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/screens/home/components/ADD/add_subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddChapterWidget extends StatefulWidget {
  const AddChapterWidget({super.key});

  @override
  State<AddChapterWidget> createState() => _AddChapterWidgetState();
}

class _AddChapterWidgetState extends State<AddChapterWidget> {
  // List<Chapter> chapters = [];
  List<LectureVideo> lectures = [];
  List<PDF> notes = [];
  List<PDF> assignments = [];
  String cnameController = '';
  ExpansionTileController lectureTileController = ExpansionTileController();
  ExpansionTileController notesTileController = ExpansionTileController();
  ExpansionTileController assignmentTileController = ExpansionTileController();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'Chapter Key');
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, ststate) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Chapter'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      chapters.add(Chapter(
                          assignments: assignments,
                          lectures: lectures,
                          name: cnameController,
                          notes: notes));
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Add this chapter to subject')),
            )
          ],
        ),
        body: Container(
          color: AppColors.greyColor,
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(
              horizontal: context.width * 0.3, vertical: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                      onChanged: (v) {
                        cnameController = v;
                      },
                      fieldName: 'Chapter Name'),
                  ExpansionTile(
                      title: const Text('Lectures'),
                      trailing: FilledButton(
                          onPressed: () async {
                            String nameController = '';
                            String urlController = '';
                            String imgUrl = '';
                            final GlobalKey<FormState> dialogeFormKey =
                                GlobalKey<FormState>();
                            await showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                        builder: (context, ststate) {
                                      return AlertDialog(
                                        content: Form(
                                          key: dialogeFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextField(
                                                  onChanged: (v) {
                                                    nameController = v;
                                                  },
                                                  fieldName: 'Name'),
                                              CustomTextField(
                                                  onChanged: (v) {
                                                    urlController = v;
                                                  },
                                                  fieldName: 'URL'),
                                              const SizedBox(height: 10),
                                              if (imgUrl == '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(),
                                                    FilledButton(
                                                        onPressed: () async {
                                                          await chooseIMGFun(
                                                                  context)
                                                              .then((value) =>
                                                                  imgUrl = value
                                                                      .url);
                                                          ststate(() {});
                                                        },
                                                        child: const Text(
                                                            'Choose Thumbnail'))
                                                  ],
                                                ),
                                              if (imgUrl != '')
                                                Image.network(
                                                  imgUrl,
                                                  height: 100,
                                                )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                if (urlController
                                                    .startsWith('http')) {
                                                  if (dialogeFormKey
                                                          .currentState
                                                          ?.validate() ==
                                                      true) {
                                                    lectures.add(LectureVideo(
                                                        time: DateTime.now(),
                                                        name: nameController,
                                                        thumbnail: imgUrl,
                                                        url: urlController));
                                                    lectureTileController
                                                        .expand();

                                                    Get.back();
                                                    setState(() {});
                                                  }
                                                } else {
                                                  Get.snackbar('Invalid URL',
                                                      'Please Enter a valid url');
                                                }
                                              },
                                              child: const Text('Ok')),
                                        ],
                                      );
                                    }));
                          },
                          child: const Text('Add Lecture')),
                      controller: lectureTileController,
                      children: lectures
                          .map((lecture) => Card(
                                child: ListTile(
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      lectures.remove(lecture);
                                      setState(() {});
                                    },
                                  ),
                                  leading: Text((lectures.indexOf(lecture) + 1)
                                      .toString()),
                                  title: Text(lecture.name.toString()),
                                  subtitle: Text(lecture.url.toString()),
                                ),
                              ))
                          .toList()),
                  if (lectures.isNotEmpty)
                    ExpansionTile(
                      controller: notesTileController,
                      title: const Text('Notes'),
                      trailing: FilledButton(
                          onPressed: () async {
                            String nameController = '';
                            String urlController = '';
                            final GlobalKey<FormState> formKeyDialoge =
                                GlobalKey<FormState>();
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Form(
                                        key: formKeyDialoge,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomTextField(
                                                onChanged: (v) {
                                                  nameController = v;
                                                },
                                                fieldName: 'Name'),
                                            CustomTextField(
                                                onChanged: (v) {
                                                  urlController = v;
                                                },
                                                fieldName: 'URL'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              if (urlController
                                                  .startsWith('http')) {
                                                if (formKeyDialoge.currentState
                                                        ?.validate() ==
                                                    true) {
                                                  notes.add(PDF(
                                                      time: DateTime.now(),
                                                      name: nameController,
                                                      url: urlController));
                                                  notesTileController.expand();
                                                  Get.back();
                                                  ststate(() {});
                                                }
                                              } else {
                                                Get.snackbar('Invalid URL',
                                                    'Please enter valid URL');
                                              }
                                            },
                                            child: const Text('Ok')),
                                      ],
                                    ));
                          },
                          child: const Text('Add Notes')),
                      children: notes
                          .map((e) => Card(
                                child: ListTile(
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      notes.remove(e);
                                      setState(() {});
                                    },
                                  ),
                                  leading:
                                      Text((notes.indexOf(e) + 1).toString()),
                                  title: Text(e.name.toString()),
                                  subtitle: Text(e.url.toString()),
                                ),
                              ))
                          .toList(),
                    ),
                  if (notes.isNotEmpty)
                    ExpansionTile(
                        controller: assignmentTileController,
                        title: const Text('Assignments'),
                        trailing: FilledButton(
                            onPressed: () async {
                              String nameController = '';
                              String urlController = '';
                              final GlobalKey<FormState> dlKey =
                                  GlobalKey<FormState>();
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Form(
                                          key: dlKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextField(
                                                  onChanged: (v) {
                                                    nameController = v;
                                                  },
                                                  fieldName: 'Name'),
                                              CustomTextField(
                                                  onChanged: (v) {
                                                    urlController = v;
                                                  },
                                                  fieldName: 'URL'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                if (urlController
                                                    .startsWith('http')) {
                                                  if (dlKey.currentState
                                                          ?.validate() ==
                                                      true) {
                                                    assignments.add(PDF(
                                                        time: DateTime.now(),
                                                        name: nameController,
                                                        url: urlController));
                                                    assignmentTileController
                                                        .expand();
                                                    Get.back();
                                                    ststate(() {});
                                                  }
                                                } else {
                                                  Get.snackbar('Invalid URL',
                                                      'Please enter valid URL');
                                                }
                                              },
                                              child: const Text('Ok')),
                                        ],
                                      ));
                            },
                            child: const Text('Add Assignment')),
                        children: assignments
                            .map((assignment) => Card(
                                  child: ListTile(
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        assignments.remove(assignment);
                                        setState(() {});
                                      },
                                    ),
                                    leading: Text(
                                        (assignments.indexOf(assignment) + 1)
                                            .toString()),
                                    title: Text(assignment.name.toString()),
                                    subtitle: Text(assignment.url.toString()),
                                  ),
                                ))
                            .toList()),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
