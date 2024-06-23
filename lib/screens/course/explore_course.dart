import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/constants/widgets/announcement_card.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/screens/course/components/teacher_card.dart';
import 'package:course_app/screens/course/components/view_chapters.dart';
import 'package:course_app/screens/views/confirm_purchase.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreCourseScreen extends StatefulWidget {
  const ExploreCourseScreen(
      {super.key,
      required this.course,
      required this.isPurchased,
      this.tabIndex = 0});
  final Course course;
  final bool isPurchased;
  final int tabIndex;

  @override
  State<ExploreCourseScreen> createState() => _ExploreCourseScreenState();
}

class _ExploreCourseScreenState extends State<ExploreCourseScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController!.index = widget.tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isPurchased ||
              widget.course.id == dummyCourse.id
          ? SizedBox()
          : FloatingActionButton.extended(
              onPressed: () {
                Get.off(() => ConfirmCoursePurchasePage(course: widget.course));
              },
              label: Text('Buy Now'),
            ),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leadingWidth: 35,
        title: Text(widget.course.title),
        bottom: TabBar(
          isScrollable: true,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Description',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'All Classes',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Announcements',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: tabController,
        children: [
          DescriptionView(course: widget.course),
          AllClassesView(
              course: widget.course, isPurchased: widget.isPurchased),
          AnnouncementsView(announcements: widget.course.announcements ?? [])
        ],
      ),
    );
  }
}

class DescriptionView extends StatelessWidget {
  const DescriptionView({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: course.img.url,
                  errorWidget: ((context, url, error) {
                    return SizedBox();
                  }),
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 10),
              Text(course.description),
              const Divider(),
              const SizedBox(height: 20),
              if (course.teachers.isNotEmpty)
                const Text('Know Your Teachers',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              if (course.teachers.isNotEmpty) const SizedBox(height: 10)
            ],
          )),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: course.teachers.length,
                  itemBuilder: (context, index) {
                    return TeacherCard(course: course, index: index);
                  }),
            ),
          ),
          if (course.faq.isNotEmpty)
            const SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(height: 20),
                  Text('FAQs',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  SizedBox(height: 10)
                ],
              ),
            ),
          SliverList.builder(
              itemCount: course.faq.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    leading: Text('Q${index + 1}'),
                    title: Text(course.faq[index].question),
                    children: [Text(course.faq[index].answer)],
                  ),
                );
              })
        ],
      ),
    );
  }
}

class AllClassesView extends StatelessWidget {
  const AllClassesView(
      {super.key, required this.course, required this.isPurchased});
  final Course course;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: course.subjects
              .map((subject) => InkWell(
                    onTap: () {
                      Get.to(() => ViewChaptersList(
                          subject: subject, isPurchased: isPurchased));
                      debugPrint(subject.image.url.toString());
                    },
                    child: Column(
                      children: [
                        if (subject.image.url.isEmpty)
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            child: CachedNetworkImage(
                                imageUrl:
                                    'https://www.pngitem.com/pimgs/b/201-2014927_research-icon-png.png'),
                          ),
                        if (subject.image.url.isNotEmpty)
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                    imageUrl: subject.image.url)),
                          ),
                        Text(subject.name),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class AnnouncementsView extends StatelessWidget {
  const AnnouncementsView({super.key, required this.announcements});
  final List<AnnounmentsModel> announcements;

  @override
  Widget build(BuildContext context) {
    announcements.sort((a, b) => b.time.compareTo(a.time));
    return Scaffold(
      body: (announcements).isEmpty
          ? Center(
              child: EmptyWidget(
                packageImage: PackageImage.Image_2,
                title: 'No Announcement Found',
                hideBackgroundAnimation: true,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return AnnouncementCard(announment: announcements[index]);
                  }),
            ),
    );
  }
}
