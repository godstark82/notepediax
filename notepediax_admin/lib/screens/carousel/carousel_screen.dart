import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_admin/providers/carousel_provider.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/screens/carousel/components/add_carousel.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Carousel'),
        actions: [
          FilledButton.icon(
              onPressed: () {
                if (context.read<CategoryProvider>().categories.isEmpty ||
                    context.read<CourseProvider>().courses.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              'Warning!!!',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: const Text(
                                'Have you created categories & courses before proceeding? \n You should create a cateogory & course before proceeding.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Back')),
                            ],
                          ));
                } else {
                  Get.back();
                  Get.to(() => const AddCarouselScreen());
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Carousel'))
        ],
      ),
      body: FutureBuilder(
          future: context.read<CarouselProvider>().fetchCarousel(),
          builder: (context, carouselProvder) {
            if (carouselProvder.hasData == true) {
              return ListView.builder(
                  itemCount: context.watch<CarouselProvider>().carousels.length,
                  itemBuilder: (context, index) {
                    log('Carousels:: ${context.read<CarouselProvider>().carousels.length}');
                    return Card(
                      child: ExpansionTile(
                        leading: Text((index + 1).toString()),
                        title: Text(context
                            .watch<CarouselProvider>()
                            .carousels[index]
                            .carouselTitle),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this carousel?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                context
                                                    .read<CarouselProvider>()
                                                    .deleteCarousel(index);
                                                Get.back();
                                              },
                                              child: const Text('Delete')),
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        children: [
                          CachedNetworkImage(
                              imageUrl: context
                                  .read<CarouselProvider>()
                                  .carousels[index]
                                  .image
                                  .url)
                        ],
                      ),
                    );
                  });
            } else if (carouselProvder.hasError) {
              return const Center(
                  child: Text(
                'Error Found',
                style: TextStyle(color: Colors.black),
              ));
            } else if (context.read<CarouselProvider>().carousels.isEmpty) {
              return Center(
                child: EmptyWidget(
                  title: 'No Categories Created',
                  packageImage: PackageImage.Image_4,
                  hideBackgroundAnimation: true,
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
