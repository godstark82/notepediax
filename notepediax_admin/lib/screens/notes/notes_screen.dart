import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/notes_provider.dart';
import 'package:course_admin/screens/notes/components/add_notes_screen.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          FilledButton.icon(
              onPressed: () {
                if (context.read<CategoryProvider>().categories.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              'Warning!!!',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: const Text(
                                'Have you created categories before proceeding? \n You should create a cateogory before proceeding.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Back')),
                            ],
                          ));
                } else {
                  Get.back();
                  Get.to(() => const AddNoteScreen());
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Notes'))
        ],
      ),
      body: context.watch<NotesProvider>().notes.isEmpty
          ? Center(
              child: EmptyWidget(
                title: 'No Notes Founded',
                packageImage: PackageImage.Image_4,
                hideBackgroundAnimation: true,
              ),
            )
          : ListView.builder(
              itemCount: context.watch<NotesProvider>().notes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            final notes =
                                context.read<NotesProvider>().notes[index];
                            return AlertDialog(
                              title: Text(notes.title),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (notes.image.url.isNotEmpty)
                                    Image.network(notes.image.url.toString()),
                                  Text(notes.description),
                                  Text('Price: ${notes.price}'),
                                  Text('Total PDFS: ${notes.pdfs.length}'),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: notes.pdfs
                                        .map((e) => Card(
                                              child: ListTile(
                                                isThreeLine: true,
                                                title: Text(e.name.toString()),
                                                subtitle: SelectableText(
                                                    e.url.toString()),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Close'))
                              ],
                            );
                          });
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text((index + 1).toString()),
                    ),
                    subtitle: Text(context
                        .read<NotesProvider>()
                        .notes[index]
                        .price
                        .toString()),
                    title:
                        Text(context.read<NotesProvider>().notes[index].title),
                    trailing: isLoading == true
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await context
                                  .read<NotesProvider>()
                                  .deleteItem(
                                      index,
                                      context
                                          .read<NotesProvider>()
                                          .notes[index])
                                  .whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                            icon: const Icon(Icons.delete, color: Colors.red)),
                  ),
                );
              }),
    );
  }
}
