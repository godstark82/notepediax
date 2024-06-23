import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/providers/gallery_provider.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Category'),
        actions: [
          FilledButton.icon(
              onPressed: () async {
                final TextEditingController nameController =
                    TextEditingController();
                String? img;
                bool isLoading = false;
                await showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                          builder: (context, ststate) => AlertDialog(
                            title: const Text('Add Category'),
                            content: SizedBox(
                              height: context.height * 0.4,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please fill this field';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Category Name',
                                        label: Text('Name'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Consumer<GalleryProvider>(
                                      builder: (context, galleryProvider, _) =>
                                          FilledButton(
                                              onPressed: () async {
                                                await chooseIMGFun(context)
                                                    .then((value) =>
                                                        img = value.url);
                                                ststate(() {});
                                              },
                                              child: const Text('Pick Image')),
                                    ),
                                    const SizedBox(height: 10),
                                    if (img != null)
                                      Image.network(
                                        img!,
                                        height: context.height * 0.25,
                                        width: context.height * 0.25,
                                        fit: BoxFit.contain,
                                      )
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ==
                                            true &&
                                        img != null) {
                                      isLoading = true;
                                      ststate(() {});
                                      context
                                          .read<CategoryProvider>()
                                          .createCategory(Category(
                                            name: nameController.text,
                                            img: img,
                                          ))
                                          .whenComplete(() {
                                        isLoading = false;
                                      });
                                      Get.back();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Please fill all fields'),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Create'))
                            ],
                          ),
                        ));
              },
              icon: const Icon(Icons.add),
              label: const Text('New Category')),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: context.read<CategoryProvider>().fetchCategories(),
        builder: (context, snapshot) => context
                .watch<CategoryProvider>()
                .categories
                .isEmpty
            ? Center(
                child: EmptyWidget(
                  title: 'No Categories Created',
                  packageImage: PackageImage.Image_4,
                  hideBackgroundAnimation: true,
                ),
              )
            : ListView.builder(
                itemCount: context.read<CategoryProvider>().categories.length,
                itemBuilder: (context, idx) {
                  return ExpansionTile(
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Do you really want to delete this category'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            context
                                                .read<CategoryProvider>()
                                                .deleteCategory(idx)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    leading: Image.network(context
                        .watch<CategoryProvider>()
                        .categories[idx]
                        .img
                        .toString()),
                    title: Text(context
                        .watch<CategoryProvider>()
                        .categories[idx]
                        .name
                        .toString()),
                    subtitle: Text(
                        'Total ${context.read<CourseProvider>().courses.where((element) => element.category.name == context.watch<CategoryProvider>().categories[idx].name).toList().length} Courses in this category'),
                    children: context
                        .read<CourseProvider>()
                        .courses
                        .where((element) =>
                            element.category.name ==
                            context
                                .read<CategoryProvider>()
                                .categories[idx]
                                .name)
                        .toList()
                        .map((item) => Card(
                              child: ListTile(
                                leading: Text((context
                                            .read<CourseProvider>()
                                            .courses
                                            .indexOf(item) +
                                        1)
                                    .toString()),
                                title: Text(item.title),
                              ),
                            ))
                        .toList(),
                  );
                }),
      ),
    );
  }
}
