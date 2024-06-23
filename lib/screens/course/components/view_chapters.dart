import 'package:course_app/models/course_model.dart';
import 'package:course_app/screens/views/chapter_view.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewChaptersList extends StatelessWidget {
  const ViewChaptersList(
      {super.key, required this.subject, required this.isPurchased});
  final Subject subject;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        elevation: 1,
      ),
      body: subject.chapters!.isEmpty
          ? Center(
              child: EmptyWidget(
              packageImage: PackageImage.Image_4,
              hideBackgroundAnimation: true,
              title: 'No Chapters Found',
            ))
          : ListView.builder(
              itemCount: subject.chapters?.length,
              itemBuilder: (context, index) => Card(
                color: Theme.of(context).cardColor,
                    child: ListTile(
                      onTap: () {
                        Get.to(() => ChapterView(
                            chapter: subject.chapters![index],
                            purchased: isPurchased));
                      },
                      leading: Text('${index + 1}'),
                      title: Text(subject.chapters![index].name),
                      
                      subtitle: Text(
                          '${subject.chapters?[index].lectures?.length} Leactures'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )),
    );
  }
}
