
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/providers/gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<GalleryImage> chooseIMGFun(
  BuildContext context,
) async {
  int? selectedIndex;
  late GalleryImage choosedImage;
  List<bool> isSelected = List.generate(
      context.read<GalleryProvider>().gallery.length, (index) => false);
  await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, ststate) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text('Choose Image',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10),
                        itemCount:
                            context.read<GalleryProvider>().gallery.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Checkbox(
                                      value: isSelected[index],
                                      onChanged: (value) {
                                        ststate(() {
                                          isSelected = List.generate(
                                              isSelected.length,
                                              (index) => false,
                                              growable: false);
                                          isSelected[index] = true;
                                        });
                                      })
                                ],
                              ),
                              Image.network(
                                context
                                    .read<GalleryProvider>()
                                    .gallery[index]
                                    .url,
                                height: 100,
                                width: 100,
                                opacity: Animation.fromValueListenable(
                                    ValueNotifier(
                                        selectedIndex != index ? 0.9 : 1)),
                              ),
                            ],
                          );
                        }),
                  ),
                  const Divider(),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                isSelected = List.generate(
                                    isSelected.length, (index) => false);
                                ststate(() {});
                              },
                              child: const Text('Clear')),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    if (isSelected.contains(true)) {
                                      final index = isSelected.indexOf(true);
                                      choosedImage = context
                                          .read<GalleryProvider>()
                                          .gallery[index];
                                      Get.back(result: choosedImage);
                                    }
                                  },
                                  child: const Text('Ok')),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            );
          }));

  return choosedImage;
}
