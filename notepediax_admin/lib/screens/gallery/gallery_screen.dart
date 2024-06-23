import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/providers/gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GalleryImage? img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyGallery (long press for more options)'),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<GalleryProvider>().uploadToStorage();
        },
        child: const Icon(Icons.upload),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: FutureBuilder(
          future: context.read<GalleryProvider>().fetchGallery(),
          builder: (context, snapshot) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10),
                itemCount: context.watch<GalleryProvider>().gallery.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.delete,
                                    color: Colors.red, semanticLabel: 'Delete'),
                                title: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  Get.back();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: const Text(
                                                'Do you really want to delete this image from Gallery?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<GalleryProvider>()
                                                        .deleteImage(context
                                                            .read<
                                                                GalleryProvider>()
                                                            .gallery[index]
                                                            .ref);
                                                    Get.back();
                                                  },
                                                  child: const Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red))),
                                            ],
                                          ));
                                },
                              )
                            ],
                          ),
                        )),
                      );
                    },
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog.fullscreen(
                              child: Image.network(context
                                  .read<GalleryProvider>()
                                  .gallery[index]
                                  .url)));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        context
                            .read<GalleryProvider>()
                            .gallery[index]
                            .url
                            .toString(),
                        height: 100,
                        fit: BoxFit.contain,
                        width: 100,
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
