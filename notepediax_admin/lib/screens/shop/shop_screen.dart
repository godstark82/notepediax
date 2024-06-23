import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/store_provider.dart';
import 'package:course_admin/screens/shop/components/add_shopitem.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Items'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
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
                    Get.to(() => const AddShopItemScreen());
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Item')),
          )
        ],
      ),
      body: context.watch<StoreProvider>().storeItems.isEmpty
          ? Center(
              child: EmptyWidget(
                title: 'No Items Found',
                packageImage: PackageImage.Image_4,
                hideBackgroundAnimation: true,
              ),
            )
          : ListView.builder(
              itemCount: context.watch<StoreProvider>().storeItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            final storeItem =
                                context.read<StoreProvider>().storeItems[index];
                            return AlertDialog(
                              title: Text(storeItem.title),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (storeItem.image.isNotEmpty)
                                    Image.network(storeItem.image.toString()),
                                  Text(storeItem.description),
                                  Text('Price: ${storeItem.price}'),
                                  Text('Category: ${storeItem.category.name}'),
                                  const SizedBox(height: 10),
                                  SelectableText(
                                      'Instagram URL: ${storeItem.instaUrl}')
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
                        .read<StoreProvider>()
                        .storeItems[index]
                        .price
                        .toString()),
                    title: Text(
                        context.read<StoreProvider>().storeItems[index].title),
                    trailing: isLoading == true
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await context
                                  .read<StoreProvider>()
                                  .deleteItem(
                                      index,
                                      context
                                          .read<StoreProvider>()
                                          .storeItems[index])
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
