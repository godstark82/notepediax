import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/constants/widgets/input_widget.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/screens/home/components/ADD/add_chapter.dart';
import 'package:course_admin/screens/home/components/ADD/add_subject.dart';
import 'package:course_admin/screens/home/components/EDIT/edit_chapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditSubjectWidget extends StatefulWidget {
  const EditSubjectWidget(
      {super.key, required this.subjectIndex, required this.courseIndex});
  final int courseIndex;
  final int subjectIndex;

  @override
  State<EditSubjectWidget> createState() => _EditSubjectWidgetState();
}

class _EditSubjectWidgetState extends State<EditSubjectWidget> {
  // List<Chapter> chapters = [];
  String nameController = '';
  GalleryImage? image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    final subject = context
        .read<CourseProvider>()
        .courses[widget.courseIndex]
        .subjects[widget.subjectIndex];
    chapters = subject.chapters ?? [];
    nameController = subject.name;
    image = subject.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Edit Subject ${widget.subjectIndex}'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
                onPressed: () async {
                  final newChapters =
                      chapters.reversed.toList().reversed.toList();
                  if (formKey.currentState?.validate() == true &&
                      chapters.isNotEmpty) {
                    final subject = Subject(
                        name: nameController,
                        chapters: newChapters,
                        image: image ??
                            GalleryImage(
                                url:
                                    'https://drive.google.com/uc?export=download&id=1PUZwWTXML70DyYnGM5Ig9DgljClqEtF6',
                                ref: 'ref'));
                    await context.read<CourseProvider>().updateSubject(
                        subject, widget.courseIndex, widget.subjectIndex);
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please fill all the fields');
                  }
                },
                child: const Text('Update Subject')),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Container(
            // height: context.screenHeight,
            margin: EdgeInsets.symmetric(horizontal: context.width * 0.3),
            color: AppColors.greyColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InputWidget(
                      heading: 'Subject Name',
                      widget: CustomTextField(
                          initialValue: nameController,
                          onChanged: (value) {
                            nameController = value;
                          },
                          fieldName: 'Name')),
                  InputWidget(
                      heading: 'Chapters',
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          FilledButton(
                            onPressed: () async {
                              await Get.to(() => const AddChapterWidget());

                              setState(() {});
                            },
                            child: const Text('Add Chapter'),
                          )
                        ],
                      )),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(chapters[index].name),
                            subtitle: Text(
                                chapters[index].lectures!.length.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Get.to(() => EditChapterWidget(
                                              courseIndex: widget.courseIndex,
                                              subjectIndex: widget.subjectIndex,
                                              chapterIndex: index))
                                          ?.then((value) => setState(() {
                                                fetchData();
                                              }));
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue)),
                                IconButton(
                                  onPressed: () {
                                    chapters.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  InputWidget(
                      heading: 'Graphics Art',
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          FilledButton(
                            onPressed: () async {
                              await chooseIMGFun(context)
                                  .then((value) => image = value);
                              setState(() {});
                            },
                            child: const Text('Add Image'),
                          )
                        ],
                      )),
                  if (image != null) Image(image: NetworkImage(image!.url))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
