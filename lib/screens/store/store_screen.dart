// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:course_app/models/store_item_model.dart';
import 'package:course_app/provider/category_provider.dart';
import 'package:course_app/provider/store_provider.dart';
import 'package:course_app/screens/home/components/filters.dart';
import 'package:course_app/screens/store/search_store.dart';
import 'package:course_app/screens/store/store_tile.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<StoreItemModel> storeItems = [];

  void increasingFunction() {
    storeItems.sort((a, b) => a.time.compareTo(b.time));
    setState(() {});
  }

  void decreasingFunction() {
    storeItems.sort((a, b) => b.time.compareTo(a.time));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    storeItems = context.read<StoreProvider>().storeItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: InkWell(
          onTap: () {
            Get.to(() => SearchStorePage());
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: GradientBoxBorder(
                      width: 2,
                      gradient: LinearGradient(colors: const [
                        Colors.blue,
                        Colors.red,
                        Colors.yellow,
                        Colors.green
                      ]))),
              width: context.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [SizedBox(width: 12), Text('Search...')],
              )),
        )),
        SliverToBoxAdapter(
            child: SizedBox(
                height: 50,
                child: FilterViewHome(
                    showSheet: true,
                    sheetFunction: () async {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16))),
                          builder: (context) => BottomSheet(
                              onClosing: () {},
                              builder: (context) => Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Filter',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextButton(
                                                onPressed: () {
                                                  storeItems = context
                                                      .read<StoreProvider>()
                                                      .storeItems;
                                                  setState(() {});
                                                  Get.back();
                                                },
                                                child: Text('Clear Filter'))
                                          ],
                                        ),
                                        ListView(
                                          shrinkWrap: true,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: context
                                              .read<CategoryProvider>()
                                              .categories
                                              .map((item) => ListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        storeItems = context
                                                            .read<
                                                                StoreProvider>()
                                                            .storeItems
                                                            .where((element) =>
                                                                element.category
                                                                    .name ==
                                                                item.name)
                                                            .toList();
                                                      });
                                                      Get.back();
                                                    },
                                                    title: '${item.name}'
                                                        .text
                                                        .make(),
                                                    subtitle:
                                                        'Click to show only ${item.name} items'
                                                            .text
                                                            .make(),
                                                    trailing: Text(
                                                        '${storeItems.where((element) => element.category.name == item.name).length} Items'),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  )));
                    },
                    decreasingFn: decreasingFunction,
                    increasingFn: increasingFunction))),
        storeItems.isEmpty
            ? SliverToBoxAdapter(
                child: EmptyWidget(
                  hideBackgroundAnimation: true,
                  packageImage: PackageImage.Image_3,
                  title: 'No Items Found',
                ),
              )
            : SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: storeItems.length,
                itemBuilder: (context, index) {
                  return StoreTile(storeItem: storeItems[index], index: index);
                },
              )
      ],
    ));
  }
}
