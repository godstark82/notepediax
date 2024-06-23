import 'package:course_admin/constants/widgets/custom_textfield.dart';
import 'package:course_admin/constants/widgets/image_chooser.dart';
import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/models/store_item_model.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddShopItemScreen extends StatefulWidget {
  const AddShopItemScreen({super.key});

  @override
  State<AddShopItemScreen> createState() => _AddShopItemScreenState();
}

class _AddShopItemScreenState extends State<AddShopItemScreen> {
  String? title, description;
  Category? selectedCategory;
  double? price;
  String? image;
  String? instaUrl;
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
        title: const Text('Add New ShopItem'),
        actions: [
          FilledButton.icon(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  isLoading = true;
                  setState(() {});
                  context
                      .read<StoreProvider>()
                      .addNewStoreItem(StoreItemModel(
                          instaUrl: instaUrl!,
                          category: selectedCategory!,
                          description: description!,
                          image: image!,
                          price: price!,
                          time: DateTime.now(),
                          title: title!))
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
                  ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 12,)
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

                CustomTextField(
                    onChanged: (value) {
                      instaUrl = value;
                    },
                    fieldName: 'Instagram URL'),
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
                              .then((value) => image = value.url);
                          setState(() {});
                        },
                        child: const Text('Image'))
                    : Image.network(image!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
