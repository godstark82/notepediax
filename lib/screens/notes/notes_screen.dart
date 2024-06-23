import 'package:course_app/models/category_model.dart';
import 'package:course_app/models/notes_model.dart';
import 'package:course_app/provider/category_provider.dart';
import 'package:course_app/provider/notes_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/components/filters.dart';
import 'package:course_app/screens/notes/components/notes_tile.dart';
import 'package:course_app/screens/notes/components/purchased_notes_tile.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? sheetController;
  void applyFilter(Category category) {
    notesList = context
        .read<NotesProvider>()
        .notes
        .where((element) => element.category.name == category.name)
        .toList();
    setState(() {});
  }

  void sortInIncreasing() {
    notesList.sort((a, b) => a.time.compareTo(b.time));
    setState(() {});
  }

  void sortInDecreasing() {
    notesList.sort((a, b) => b.time.compareTo(a.time));
    setState(() {});
  }

  @override
  void initState() {
    notesList = context.read<NotesProvider>().notes;
    sheetController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: notesList.isEmpty ? Center(
          child: EmptyWidget(
            title: 'No Notes Found',
            packageImage: PackageImage.Image_3,
            hideBackgroundAnimation: true,
          ),
        ) : CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: FilterViewHome(
                showSheet: true,
                decreasingFn: sortInDecreasing,
                increasingFn: sortInIncreasing,
                sheetFunction: () {
                  showModalBottomSheet(
                    enableDrag: true,
                    showDragHandle: false,
                      context: context,
                      builder: (context) => BottomSheet(
                        enableDrag: true,
                        
                        animationController: sheetController,
                            onClosing: () {},
                            elevation: 0,
                            builder: (context) {
                              return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Filters',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            TextButton(
                                                onPressed: () {
                                                  notesList = context
                                                      .read<NotesProvider>()
                                                      .notes;
                                                  setState(() {});
                                                  Get.back();
                                                },
                                                child: Text('Clear Filter'))
                                          ],
                                        ),
                                        Column(
                                            children: context
                                                .read<CategoryProvider>()
                                                .categories
                                                .map((category) => ListTile(
                                                      onTap: () {
                                                        applyFilter(category);
                                                        Get.back();
                                                      },
                                                      subtitle: Text(
                                                          'Tap to apply filter'),
                                                      trailing: Text(
                                                          '${context.watch<NotesProvider>().notes.where((element) => element.category.name == category.name).length} Items'),
                                                      title: Text(category.name
                                                          .toString()),
                                                    ))
                                                .toList())
                                      ],
                                    ),
                                  ));
                            },
                            backgroundColor: Theme.of(context).cardColor,
                          ));
                })),
        SliverList.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              // print(context.read<NotesProvider>().notes);
              // print(context.read<UserProvider>().userNotes.toString());
              if (context
                  .watch<UserProvider>()
                  .userNotes
                  .contains(notesList[index])) {
                return PurchasedNotesTile(notes: notesList[index]);
              } else {
                return NotesTile(notes: notesList[index]);
              }
            })
      ],
    ));
  }
}

List<NotesModel> notesList = [];
