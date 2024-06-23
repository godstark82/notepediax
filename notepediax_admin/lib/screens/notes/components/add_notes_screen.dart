import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/models/notes_model.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  List<PDF> pdfs = [];
  String? title, description;
  Category? selectedCategory;
  double? price;
  GalleryImage? image;
  bool isLoading = false;
  List<DropdownMenuItem<Category>> allCategory = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    allCategory = context
        .read<CategoryProvider>()
        .categories
        .map((category) => DropdownMenuItem(
              value: category,
              child: Text(category.name.toString()),
            ))
        .toList();
    selectedCategory = allCategory.first.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Notes'),
        actions: [
          FilledButton.icon(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  isLoading = true;
                  setState(() {});
                  context
                      .read<NotesProvider>()
                      .saveNotesToFirestore(NotesModel(
                          title: title!,
                          time: DateTime.now(),
                          category: selectedCategory!,
                          description: description!,
                          pdfs: pdfs,
                          image: image!,
                          price: price!))
                      .whenComplete(() {
                    isLoading = false;
                    setState(() {});
                    Get.back();
                  });
                } else {
                  formKey.currentState?.validate().printError();
                }
              },
              icon: const Icon(Icons.save),
              label: isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Save Data'))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.3),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    onChanged: (value) {
                      title = value;
                    },
                    fieldName: 'Title'),
                const SizedBox(height: 10),
                CustomTextField(
                    onChanged: (value) {
                      description = value;
                    },
                    fieldName: 'Description'),
                const SizedBox(height: 10),
                CustomTextField(
                    isNumerical: true,
                    onChanged: (value) {
                      price = double.parse(value);
                    },
                    fieldName: 'Price'),
                const SizedBox(height: 10),
                DropdownButton<Category>(
                    items: allCategory,
                    value: selectedCategory,
                    onChanged: (newCat) {
                      selectedCategory = newCat;
                      setState(() {});
                    }),
                const SizedBox(height: 10),
                image == null
                    ? FilledButton(
                        onPressed: () async {
                          await chooseIMGFun(context)
                              .then((value) => image = value);
                          setState(() {});
                        },
                        child: const Text('Image'))
                    : Image.network(image!.url, height: 100),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PDFS (${pdfs.length})'),
                    FilledButton(
                        onPressed: () {
                          final GlobalKey<FormState> pdfFormKey =
                              GlobalKey<FormState>();
                          String name = '';
                          String url = '';
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Add PDF'),
                                    content: Form(
                                      key: pdfFormKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                              onChanged: (value) {
                                                name = value;
                                              },
                                              fieldName: 'Name'),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                              onChanged: (value) {
                                                url = value;
                                              },
                                              fieldName: 'URL'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            if (pdfFormKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              pdfs.add(PDF(
                                                  name: name,
                                                  url: url,
                                                  time: DateTime.now()));
                                              Get.back();
                                              setState(() {});
                                            }
                                          },
                                          child: const Text('OK')),
                                    ],
                                  ));
                        },
                        child: const Text('Add PDF')),
                  ],
                ),
                const SizedBox(height: 10),
                if (pdfs.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: pdfs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text((index + 1).toString()),
                          title: Text(pdfs[index].name.toString()),
                          subtitle: Text(pdfs[index].name.toString()),
                        );
                      })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
