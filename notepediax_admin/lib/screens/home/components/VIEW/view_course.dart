// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/constants/widgets/input_widget.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/screens/home/components/EDIT/edit_course.dart';
import 'package:course_admin/screens/home/components/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ViewCourseScreen extends StatefulWidget {
  const ViewCourseScreen({super.key, required this.index});
  final int index;
  @override
  State<ViewCourseScreen> createState() => _ViewCourseScreenState();
}

class _ViewCourseScreenState extends State<ViewCourseScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Course course = context.watch<CourseProvider>().courses[widget.index];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: const Text('Course Details'),
        actions: [
          FilledButton.icon(
              onPressed: () async {
                clearTempCourse();
                await Get.to(() => EditCourseWidget(courseIndex: widget.index))
                    ?.whenComplete(() async {
                  // await context.read<CourseProvider>().fetchCourses();
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Course')),
          const SizedBox(width: 12),
        ],
      ),
      body: Row(
        // Course Details in a Column Card Here
        children: [
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(color: AppColors.greyColor),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(course.img.url),
                              const SizedBox(height: 10),
                              Text(course.title,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 10),
                              Text(course.description,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 20),
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Price:',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      const SizedBox(width: 20),
                                      Text(course.price.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.lineThrough))
                                    ],
                                  )),
                              const SizedBox(height: 12),
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Discount Shown:',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      const SizedBox(width: 20),
                                      Text(course.discount.toString(),
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ],
                                  )),
                              const SizedBox(height: 12),
                            ]))),
              )),
          // Rest Of UI Will Show All the details of the chapters
          Expanded(
              flex: 5,
              child: Scaffold(
                appBar: TabBar(controller: tabController, tabs: [
                  const Padding(
                      padding: EdgeInsets.all(8.0), child: Text('Details')),
                  const Padding(
                      padding: EdgeInsets.all(8.0), child: Text('Subjects')),
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Announcements'))
                ]),
                body: TabBarView(
                  controller: tabController,
                  children: [
                    Center(
                      child: Card(
                        shape: const ContinuousRectangleBorder(),
                        child: SizedBox(
                          width: context.width * 0.3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                InputWidget(
                                    heading:
                                        'Teachers (${course.teachers.length})',
                                    widget: const SizedBox()),
                                const Divider(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: course.teachers.length,
                                    itemBuilder: (context, index) => ListTile(
                                          title:
                                              Text(course.teachers[index].name),
                                          leading: Image.network(
                                              course.teachers[index].img),
                                          trailing: TextButton.icon(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Dialog(
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Image.network(course
                                                                          .teachers[
                                                                              index]
                                                                          .img),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Text(course
                                                                          .teachers[
                                                                              index]
                                                                          .name),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Text(course
                                                                          .teachers[
                                                                              index]
                                                                          .desc),
                                                                      const SizedBox(
                                                                          height:
                                                                              10)
                                                                    ]))));
                                              },
                                              icon: const Icon(
                                                  Icons.remove_red_eye),
                                              label:
                                                  const Text('View Teacher')),
                                        )),
                                const SizedBox(height: 10),
                                InputWidget(
                                    heading: 'FAQs (${course.faq.length})',
                                    widget: const SizedBox()),
                                const Divider(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: course.faq.length,
                                    itemBuilder: (context, index) =>
                                        ExpansionTile(
                                          title: Text(
                                              'Q. ${course.faq[index].question}'),
                                          children: [
                                            Text(
                                                'Ans: ${course.faq[index].answer}')
                                          ],
                                        )),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //
                    //
                    //
                    // Widget for Subjects TAB
                    Center(
                        child: Card(
                      shape: const ContinuousRectangleBorder(),
                      child: SizedBox(
                        width: context.width * 0.3,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const InputWidget(
                              heading: 'Subjects', widget: SizedBox()),
                          ListView.builder(
                              itemCount: course.subjects.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  // initiallyExpanded: true,
                                  leading: Text('${index + 1}'),
                                  title: Text(course.subjects[index].name),
                                  children: course.subjects[index].chapters!
                                      .map((chapter) => ListTile(
                                            title: Text(chapter.name),
                                            subtitle: Text(
                                                'Total Lectures: ${chapter.lectures?.length}'),
                                            trailing: FilledButton.icon(
                                                onPressed: () {
                                                  TabController tabController =
                                                      TabController(
                                                          length: 3,
                                                          vsync: this);
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) => Dialog(
                                                                child: Scaffold(
                                                                  appBar:
                                                                      AppBar(
                                                                    title: Text(
                                                                        chapter
                                                                            .name),
                                                                    bottom: TabBar(
                                                                        controller:
                                                                            tabController,
                                                                        tabs: [
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text('Lecures'),
                                                                          ),
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text('Notes'),
                                                                          ),
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text('Assignments'),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  body: TabBarView(
                                                                      controller:
                                                                          tabController,
                                                                      children: [
                                                                        ListView
                                                                            .builder(
                                                                          itemCount: chapter
                                                                              .lectures
                                                                              ?.length,
                                                                          itemBuilder: (context, idx) =>
                                                                              Card(
                                                                            child:
                                                                                ListTile(
                                                                              leading: chapter.lectures![index].thumbnail.isNotEmpty ? Image.network(chapter.lectures![idx].thumbnail) : const Text('No Image'),
                                                                              title: Text(chapter.lectures![idx].name),
                                                                              subtitle: const Text('Click to Test the video url'),
                                                                              isThreeLine: true,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ListView
                                                                            .builder(
                                                                          itemCount: chapter
                                                                              .notes
                                                                              ?.length,
                                                                          itemBuilder: (context, idx) =>
                                                                              Card(
                                                                            child:
                                                                                ListTile(
                                                                              leading: Text('${idx + 1}'),
                                                                              title: Text(chapter.notes![idx].name.toString()),
                                                                              subtitle: const Text('Click to view'),
                                                                              isThreeLine: true,
                                                                              onTap: () {
                                                                                // Get.to(() => CustomPDFViewer(pdf: PDF(name: 'name', url: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')));
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ListView
                                                                            .builder(
                                                                          itemCount: chapter
                                                                              .assignments
                                                                              ?.length,
                                                                          itemBuilder: (context, idx) =>
                                                                              Card(
                                                                            child:
                                                                                ListTile(
                                                                              leading: Text('${idx + 1}'),
                                                                              title: Text(chapter.assignments![idx].name.toString()),
                                                                              subtitle: const Text('Click to view'),
                                                                              onTap: () {
                                                                                Get.to(() => CustomPDFViewer(pdf: chapter.assignments![idx]));
                                                                              },
                                                                              isThreeLine: true,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ));
                                                },
                                                icon: const Icon(
                                                    Icons.open_in_full),
                                                label: const Text('View More')),
                                          ))
                                      .toList(),
                                );
                              })
                        ])),
                      ),
                    )),
                    //
                    //
                    //
                    //  Widget for Announcements TAB
                    (course.announcements).isEmpty
                        ? const Center(child: Text('No Announcements yet...'))
                        : ListView.builder(
                            itemCount: course.announcements.length,
                            itemBuilder: (context, index) {
                              return ExpansionTile(
                                title:
                                    Text(course.announcements[index].adminName),
                                subtitle:
                                    Text(course.announcements[index].text),
                                leading: course.announcements[index].image != ''
                                    ? Image.network(course
                                        .announcements[index].image
                                        .toString())
                                    : const Icon(Icons.image),
                                children: [
                                  Text(course.announcements[index].text)
                                ],
                              );
                            })
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class CustomPDFViewer extends StatefulWidget {
  const CustomPDFViewer({super.key, required this.pdf});
  final PDF pdf;

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.pdf.name.toString()),
        ),
        body: Container());
  }
}
