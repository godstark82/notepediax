// ignore_for_file: use_build_context_synchronously

import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/constants/widgets/input_widget.dart';

import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/screens/home/components/ADD/add_subject.dart';
import 'package:course_admin/screens/home/components/EDIT/edit_subject.dart';
import 'package:course_admin/screens/home/components/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditCourseWidget extends StatefulWidget {
  const EditCourseWidget({super.key, required this.courseIndex});
  final int courseIndex;

  @override
  State<EditCourseWidget> createState() => _EditCourseWidgetState();
}

class _EditCourseWidgetState extends State<EditCourseWidget>
    with SingleTickerProviderStateMixin {
  List<DropdownMenuItem<String>>? categoryOptions;
  String? selectedCategory;
  TabController? tabController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    categoryOptions = List.generate(
        context.read<CategoryProvider>().categories.length,
        (index) => DropdownMenuItem(
              value: context.read<CategoryProvider>().categories[index].name,
              child: Text(
                  context.read<CategoryProvider>().categories[index].name ??
                      ''),
            ));
    tabController = TabController(vsync: this, length: 3);
    fetchData();
  }

  void fetchData() {
    final course = context.read<CourseProvider>().courses[widget.courseIndex];
    tempCourse.teachers = course.teachers;
    tempCourse.faq = course.faq;
    tempCourse.subjects = course.subjects;
    tempCourse.teachers = course.teachers;
    tempCourse.title = course.title;
    tempCourse.img = course.img;
    tempCourse.description = course.description;
    tempCourse.price = course.price;
    tempCourse.discount = course.discount;
    tempCourse.announcements = course.announcements;
    tempCourse.creationTime = course.creationTime;
    selectedCategory = course.category.name;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CategoryProvider>().fetchCategories(),
        builder: (context, categoryProvider) {
          return Scaffold(
              appBar: AppBar(
                elevation: 2,
                title: Text(
                    'Edit Course ID:${context.read<CourseProvider>().courses[widget.courseIndex].id}'),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                        onPressed: () async {
                          if (tempCourse.subjects.isNotEmpty) {
                            final course = Course(
                                id: context
                                    .read<CourseProvider>()
                                    .courses[widget.courseIndex]
                                    .id,
                                faq: tempCourse.faq,
                                category: Category(
                                    name: selectedCategory,
                                    img: context
                                        .read<CategoryProvider>()
                                        .categories
                                        .firstWhere((element) =>
                                            element.name == selectedCategory)
                                        .img),
                                title: tempCourse.title,
                                img: context
                                    .read<CourseProvider>()
                                    .courses[widget.courseIndex]
                                    .img,
                                price: tempCourse.price,
                                discount: tempCourse.discount,
                                announcements: tempCourse.announcements,
                                subjects: tempCourse.subjects,
                                creationTime: context
                                    .read<CourseProvider>()
                                    .courses[widget.courseIndex]
                                    .creationTime,
                                description: tempCourse.description,
                                teachers: tempCourse.teachers);
                            await context
                                .read<CourseProvider>()
                                .updateCourse(
                                  course,
                                  widget.courseIndex,
                                )
                                .whenComplete(() async {
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              Get
                                ..back()
                                ..back();
                            });
                          } else {
                            Get.snackbar('Error', 'Please fill all the fields');
                          }
                        },
                        child: const Text('Update Course')),
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 25),
                  child: TabBar(
                      onTap: (index) {
                        setState(() {});
                      },
                      controller: tabController,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Course Info'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Subjects'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Announcements'),
                        )
                      ]),
                ),
              ),
              body: TabBarView(controller: tabController, children: [
                Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.endTop,
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                          child: const Icon(Icons.chevron_right),
                          onPressed: () {
                            if (formKey.currentState?.validate() == true &&
                                tempCourse.teachers.isNotEmpty) {
                              tabController!.animateTo(1);
                            } else {
                              Get.snackbar(
                                  'Error', 'Please fill all the fields');
                            }
                          }),
                    ),
                    body: Form(
                        key: formKey,
                        child: Center(
                            child: Container(
                                decoration:
                                    BoxDecoration(color: AppColors.greyColor),
                                width: context.width,
                                margin: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: context.width * 0.3),
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  // name
                                  InputWidget(
                                      heading: 'Course Name',
                                      widget: CustomTextField(
                                          initialValue: tempCourse.title,
                                          onChanged: (v) {
                                            tempCourse.title = v;
                                          },
                                          fieldName: 'Name')),
                                  InputWidget(
                                    heading: 'Price',
                                    widget: CustomTextField(
                                        initialValue:
                                            tempCourse.price.toString(),
                                        onChanged: (value) {
                                          tempCourse.price =
                                              double.parse(value);
                                        },
                                        fieldName: 'Price'),
                                  ),
                                  InputWidget(
                                      heading: 'Discount',
                                      widget: CustomTextField(
                                          initialValue:
                                              tempCourse.discount.toString(),
                                          onChanged: (value) {
                                            tempCourse.discount =
                                                double.parse(value);
                                          },
                                          fieldName: 'Discount')),
                                  // category
                                  InputWidget(
                                      heading: 'Category',
                                      widget: Container(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade50),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: DropdownButton<String>(
                                          underline: const SizedBox(),
                                          value: selectedCategory ??
                                              categoryOptions?.first.value,
                                          items: categoryOptions,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCategory = value;
                                            });
                                          },
                                        ),
                                      )),

                                  // desc
                                  InputWidget(
                                      heading: 'Description',
                                      widget: CustomTextField(
                                          initialValue: tempCourse.description,
                                          onChanged: (v) {
                                            tempCourse.description = v;
                                          },
                                          fieldName: 'Description')),
                                  InputWidget(
                                      heading:
                                          'Teachers (${tempCourse.teachers.isNotEmpty ? tempCourse.teachers.length : 0})',
                                      widget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          FilledButton(
                                              onPressed: () {
                                                TextEditingController name =
                                                    TextEditingController();
                                                TextEditingController desc =
                                                    TextEditingController();
                                                String teacherSubject = '';
                                                int exp = 0;
                                                String img = '';
                                                final GlobalKey<FormState>
                                                    dlKey =
                                                    GlobalKey<FormState>();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        StatefulBuilder(builder:
                                                            (context, ststate) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Add Teacher'),
                                                            content: Form(
                                                              key: dlKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (v) {
                                                                          name.text =
                                                                              v;
                                                                        },
                                                                        fieldName:
                                                                            'Teacher\'s Name'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (value) {
                                                                          desc.text =
                                                                              value;
                                                                        },
                                                                        fieldName:
                                                                            'Description'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (value) {
                                                                          teacherSubject =
                                                                              value;
                                                                        },
                                                                        fieldName:
                                                                            'Subject'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (value) {
                                                                          exp =
                                                                              int.parse(value);
                                                                        },
                                                                        fieldName:
                                                                            'Experience'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    if (img ==
                                                                        '')
                                                                      FilledButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await chooseIMGFun(context).then((value) =>
                                                                                img = value.url);
                                                                            ststate(() {});
                                                                          },
                                                                          child:
                                                                              const Text('Add Image')),
                                                                    if (img !=
                                                                        '')
                                                                      Image
                                                                          .network(
                                                                        img,
                                                                        height:
                                                                            100,
                                                                      )
                                                                  ]),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: const Text(
                                                                      'Cancel')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (dlKey.currentState?.validate() ==
                                                                            true &&
                                                                        img != null || img.isNotEmpty) {
                                                                      tempCourse.teachers.add(Teacher(
                                                                          experience:
                                                                              exp,
                                                                          subject:
                                                                              teacherSubject,
                                                                          desc: desc
                                                                              .text,
                                                                          img:
                                                                              img,
                                                                          name:
                                                                              name.text));
                                                                      setState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ok')),
                                                            ],
                                                          );
                                                        }));
                                              },
                                              child: const Text('Add Teacher'))
                                        ],
                                      )),
                                  // list of teachers
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: tempCourse.teachers.length,
                                      itemBuilder: (context, index) => Card(
                                            child: ListTile(
                                              leading: Image.network(tempCourse
                                                  .teachers[index].img),
                                              title: Text(tempCourse
                                                  .teachers[index].name),
                                              subtitle: Text(tempCourse
                                                  .teachers[index].desc),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    tempCourse.teachers
                                                        .removeAt(index);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red)),
                                            ),
                                          )),

                                  InputWidget(
                                      heading:
                                          'FAQs (${tempCourse.faq.isNotEmpty ? tempCourse.teachers.length : 0})',
                                      widget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          FilledButton(
                                              onPressed: () {
                                                String question = '';
                                                String answer = '';

                                                final GlobalKey<FormState>
                                                    dlKey =
                                                    GlobalKey<FormState>();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        StatefulBuilder(builder:
                                                            (context, ststate) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Add Teacher'),
                                                            content: Form(
                                                              key: dlKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (v) {
                                                                          question =
                                                                              v;
                                                                        },
                                                                        fieldName:
                                                                            'Question'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    CustomTextField(
                                                                        onChanged:
                                                                            (v) {
                                                                          answer =
                                                                              v;
                                                                        },
                                                                        fieldName:
                                                                            'Answer'),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                  ]),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: const Text(
                                                                      'Cancel')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (dlKey
                                                                            .currentState
                                                                            ?.validate() ==
                                                                        true) {
                                                                      tempCourse.faq.add(FAQModel(
                                                                          answer:
                                                                              answer,
                                                                          question:
                                                                              question));
                                                                      setState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ok')),
                                                            ],
                                                          );
                                                        }));
                                              },
                                              child: const Text('Add Teacher'))
                                        ],
                                      )),
                                  // list of teachers
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: tempCourse.faq.length,
                                      itemBuilder: (context, index) => Card(
                                            child: ExpansionTile(
                                              title: Text(tempCourse
                                                  .faq[index].question),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    tempCourse.faq
                                                        .removeAt(index);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red)),
                                              children: [
                                                Text(tempCourse
                                                    .faq[index].answer)
                                              ],
                                            ),
                                          )),
                                  // chapters here

                                  InputWidget(
                                      heading: 'Thumbnail',
                                      widget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          FilledButton(
                                              onPressed: () async {
                                                await chooseIMGFun(context)
                                                    .then((value) =>
                                                        tempCourse.img = value);
                                                setState(() {});
                                              },
                                              child: const Text('Choose Image'))
                                        ],
                                      )),
                                  if (tempCourse.img.url != '')
                                    Image.network(tempCourse.img.url)
                                ])))))),
                Scaffold(
                  body: Column(
                    children: [
                      InputWidget(
                          heading:
                              'Subjects (${tempCourse.subjects.isNotEmpty ? tempCourse.subjects.length : 0})',
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              FilledButton(
                                  onPressed: () async {
                                    chapters.clear();
                                    await Get.to(() => AddSubjectWidget(
                                        subjectIndex:
                                            tempCourse.subjects.length));
                                    setState(() {});
                                  },
                                  child: const Text('Add Subject'))
                            ],
                          )),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tempCourse.subjects.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(tempCourse.subjects[index].name),
                            subtitle: Text(
                                '${tempCourse.subjects[index].chapters!.length} Chapters'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Get.to(() => EditSubjectWidget(
                                              courseIndex: widget.courseIndex,
                                              subjectIndex: index))
                                          ?.then((value) => setState(() {}));
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      tempCourse.subjects.removeAt(index);
                                      setState(() {});
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Annoucements
                Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () {
                          tabController!.animateTo(1);
                        },
                        icon: const Icon(Icons.chevron_left)),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    label: const Text('New Annoucements'),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      String admin = '';
                      String msg = '';
                      String img = '';
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('New Assignment'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomTextField(
                                        onChanged: (value) {
                                          admin = value;
                                        },
                                        fieldName: 'Admin Name'),
                                    const Gap(10),
                                    CustomTextField(
                                        onChanged: (value) {
                                          msg = value;
                                        },
                                        fieldName: 'Msg'),
                                    const Gap(10),
                                    FilledButton.icon(
                                        onPressed: () {
                                          chooseIMGFun(context)
                                              .then((value) => img = value.url);
                                        },
                                        icon: const Icon(Icons.image),
                                        label: const Text('Image')),
                                    const Gap(10),
                                    if (img != '')
                                      Image.network(img, height: 100)
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        tempCourse.announcements.add(
                                            AnnouncementsModel(
                                                adminName: admin,
                                                text: msg,
                                                image: img,
                                                time: DateTime.now()));
                                        setState(() {});
                                        Get.back();
                                      },
                                      child: const Text('OK'))
                                ],
                              ));
                    },
                  ),
                  body: ListView.builder(
                      itemCount: tempCourse.announcements.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title:
                              Text(tempCourse.announcements[index].adminName),
                          subtitle: Text(tempCourse.announcements[index].text),
                          leading: tempCourse.announcements[index].image != ''
                              ? Image.network(tempCourse
                                  .announcements[index].image
                                  .toString())
                              : const Icon(Icons.image),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                tempCourse.announcements.removeAt(index);
                                setState(() {});
                              }),
                          children: [
                            Text(tempCourse.announcements[index].text)
                          ],
                        );
                      }),
                ),
              ]));
        });
  }
}
