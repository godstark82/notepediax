import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/constants/widgets/input_widget.dart';
import 'package:course_admin/models/carousel_model.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/providers/carousel_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddCarouselScreen extends StatefulWidget {
  const AddCarouselScreen({super.key});

  @override
  State<AddCarouselScreen> createState() => _AddCarouselScreenState();
}

class _AddCarouselScreenState extends State<AddCarouselScreen> {
  List<DropdownMenuItem<int>>? allCourses;
  int? selectedCourseId;
  String title = '';
  GalleryImage? image;

  @override
  void initState() {
    super.initState();
    allCourses = List.generate(
        context.read<CourseProvider>().courses.length,
        (index) => DropdownMenuItem(
              value: context.read<CourseProvider>().courses[index].id,
              child: Text(context.read<CourseProvider>().courses[index].title),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Carousel'),
        actions: [
          FilledButton(
              onPressed: () async {
                //

                await context
                    .read<CarouselProvider>()
                    .createCarousel(CarouselModel(
                        course: context
                            .read<CourseProvider>()
                            .courses
                            .firstWhere(
                                (element) => element.id == selectedCourseId),
                        carouselTitle: title,
                        image: image!))
                    .whenComplete(() => Get.back());
              },
              child: const Text('Add Carousel'))
        ],
      ),
      body: Column(
        children: [
          InputWidget(
              heading: 'Title',
              widget: CustomTextField(
                  onChanged: (value) {
                    title = value;
                  },
                  fieldName: 'Title')),
          InputWidget(
              heading: 'Course',
              widget: DropdownButton(
                items: allCourses,
                value: selectedCourseId ?? allCourses?.first.value,
                onChanged: (newValue) {
                  selectedCourseId = newValue;
                  setState(() {});
                },
              )),
          InputWidget(
              heading: 'Image',
              widget: FilledButton(
                  onPressed: () async {
                    image = await chooseIMGFun(context);
                    setState(() {});
                  },
                  child: const Text('Add Image'))),
          if (image != null) Image.network(image!.url, height: 100, width: 100),
          const SizedBox(height: 100),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.red),
              SizedBox(width: 5),
              Text(
                  'Note :- If you deleted the related Course later, you have to delete this carousel also, otherwise it will show that deleted course in the app or throw an error.')
            ],
          )
        ],
      ),
    );
  }
}
