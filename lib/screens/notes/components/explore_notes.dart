import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/models/notes_model.dart';
import 'package:course_app/screens/views/pdf_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreNotesScreen extends StatefulWidget {
  const ExploreNotesScreen({
    super.key,
    required this.notes,
    required this.isPurchased,
  });
  final NotesModel notes;
  final bool isPurchased;

  @override
  State<ExploreNotesScreen> createState() => _ExploreNotesScreenState();
}

class _ExploreNotesScreenState extends State<ExploreNotesScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.index = tabIndex;
    if (widget.isPurchased) {
      tabIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 35,
        title: Text(widget.notes.title),
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
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: tabController,
        children: [
          DescriptionView(notes: widget.notes),
          AllClassesView(notes: widget.notes, isPurchased: widget.isPurchased),
        ],
      ),
    );
  }
}

class DescriptionView extends StatelessWidget {
  const DescriptionView({super.key, required this.notes});
  final NotesModel notes;

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
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(imageUrl: notes.image.url)),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 10),
              Text(notes.description),
              const Divider(),
              const SizedBox(height: 20),
              Text('Category: ${notes.category.name}')
            ],
          )),
        ],
      ),
    );
  }
}

class AllClassesView extends StatelessWidget {
  const AllClassesView(
      {super.key, required this.notes, required this.isPurchased});
  final NotesModel notes;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
              itemCount: notes.pdfs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text((index + 1).toString()),
                    ),
                    // tileColor: Colors.white,
                    onTap: () {
                      if (isPurchased) {
                        Get.to(() => PdfViewPage(pdf: notes.pdfs[index]));
                      } else {
                        SnackBars.showRedSnackBar(
                            context: context,
                            message: 'Please purchase to unlock this');
                      }
                    },
                    title: Text(notes.pdfs[index].name.toString()),
                    subtitle: Text('Click to view'),
                    trailing: isPurchased
                        ? Icon(Icons.arrow_circle_right_outlined)
                        : Icon(Icons.lock),
                  ),
                );
              })),
    );
  }
}
