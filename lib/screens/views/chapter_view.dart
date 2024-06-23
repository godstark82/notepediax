// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:banner_listtile/banner_listtile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/screens/views/pdf_view_page.dart';
import 'package:course_app/screens/views/video_play_page.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterView extends StatefulWidget {
  const ChapterView(
      {super.key, required this.chapter, required this.purchased});
  final Chapter chapter;
  final bool purchased;

  @override
  State<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.name),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: const [
            Padding(padding: EdgeInsets.all(8.0), child: Text('Lectures')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('Notes')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('Assignments')),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Lectures
          widget.chapter.lectures!.isEmpty
              ? EmptyWidget(
                  hideBackgroundAnimation: true,
                  packageImage: PackageImage.Image_1,
                  title: 'No Lectures uploaded yet',
                )
              : ListView.builder(
                  itemCount: widget.chapter.lectures?.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Theme.of(context).cardColor,
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: BannerListTile(
                          onTap: () {
                            if (widget.purchased) {
                              Get.to(() => VideoPlayerView(
                                  chapter: widget.chapter, index: index));
                            } else {
                              SnackBars.showRedSnackBar(
                                  context: context,
                                  message:
                                      'Please Purchase this course to view content');
                            }
                          },
                          showBanner: false,
                          trailing:
                              widget.purchased ? SizedBox() : Icon(Icons.lock),
                          borderRadius: BorderRadius.circular(12),
                          imageContainer: CachedNetworkImage(
                            imageUrl: widget.chapter.lectures![index].thumbnail,
                            fit: BoxFit.cover,
                          ),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${widget.chapter.lectures![index].time}')
                              ]),
                          title: Text(
                            widget.chapter.lectures![index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ));
                  },
                ),
          widget.chapter.notes!.isEmpty
              ? EmptyWidget(
                  hideBackgroundAnimation: true,
                  packageImage: PackageImage.Image_1,
                  title: 'No Notes uploaded yet',
                )
              : ListView.builder(
                  itemCount: widget.chapter.notes?.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Theme.of(context).cardColor,
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.book),
                          subtitle: Text('Tap here to view file'),
                          onTap: () {
                            if (widget.purchased) {
                              Get.to(() => PdfViewPage(
                                  pdf: widget.chapter.notes![index]));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Please Purchase this course to view content')));
                            }
                          },

                          trailing:
                              widget.purchased ? SizedBox() : Icon(Icons.lock),

                          // backgroundColor: Colors.white,

                          title: Text(
                            widget.chapter.notes![index].name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ));
                  },
                ),
          widget.chapter.assignments!.isEmpty
              ? EmptyWidget(
                  hideBackgroundAnimation: true,
                  packageImage: PackageImage.Image_1,
                  title: 'No Assignment Found',
                )
              : ListView.builder(
                  itemCount: widget.chapter.assignments?.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Theme.of(context).cardColor,
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.quiz_outlined),
                          onTap: () {
                            if (widget.purchased) {
                              Get.to(() => PdfViewPage(
                                  pdf: widget.chapter.assignments![index]));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Please Purchase this course to view content')));
                            }
                          },
                          trailing:
                              widget.purchased ? SizedBox() : Icon(Icons.lock),
                          title: Text(
                            widget.chapter.assignments![index].name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ));
                  },
                ),
        ],
      ),
    );
  }
}
