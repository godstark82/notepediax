import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/provider/category_provider.dart';
import 'package:course_app/screens/category/category_screen.dart';
import 'package:course_app/screens/category/components/courses_in_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryViewHomeScreen extends StatelessWidget {
  const CategoryViewHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Category',
                  style: Theme.of(context).textTheme.titleSmall),
              IconButton(
                // style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8,horizontal: 10))),
                  onPressed: () {
                    Get.to(() => CategoryScreen());
                  },
                  icon: Icon(Icons.chevron_right_outlined))
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 75,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: context.read<CategoryProvider>().categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => CategoryCourses(
                                cateogry: context
                                    .read<CategoryProvider>()
                                    .categories[index]));
                          },
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                      context
                                          .read<CategoryProvider>()
                                          .categories[index]
                                          .img
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                                SizedBox(height: 5),
                            Text(
                              context
                                  .read<CategoryProvider>()
                                  .categories[index]
                                  .name
                                  .toString(),
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ])));
                })),
                SizedBox(height: 12),
      ],
    );
  }
}
