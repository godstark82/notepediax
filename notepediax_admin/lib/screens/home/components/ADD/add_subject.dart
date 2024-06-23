import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/constants/widgets/input_widget.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/screens/home/components/ADD/add_chapter.dart';
import 'package:course_admin/screens/home/components/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubjectWidget extends StatefulWidget {
  const AddSubjectWidget({
    super.key,
    required this.subjectIndex,
  });
  final int subjectIndex;

  @override
  State<AddSubjectWidget> createState() => _AddSubjectWidgetState();
}

class _AddSubjectWidgetState extends State<AddSubjectWidget> {
  GalleryImage? image;
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Add Subject'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
                onPressed: () {
                  final newChapters =
                      chapters.reversed.toList().reversed.toList();
                  if (formKey.currentState?.validate() == true) {
                    final subject = Subject(
                        name: nameController.text,
                        chapters: newChapters,
                        image: image ??
                            GalleryImage(
                                url:
                                    'https://drive.google.com/uc?export=download&id=1PUZwWTXML70DyYnGM5Ig9DgljClqEtF6',
                                ref: 'ref'));

                    tempCourse.subjects.add(subject);

                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please fill all the fields');
                  }
                },
                child: const Text('Add this subject to Course')),
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
                          onChanged: (value) {
                            nameController.text = value;
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
                              // tempCourse.subjects[widget.subjectIndex]
                              // .chapters = fetchedChapters ?? [];
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
                            trailing: IconButton(
                              onPressed: () {
                                chapters.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
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
                  if (image != null) Image.network(image!.url)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Chapter> chapters = [];
