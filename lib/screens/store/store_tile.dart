// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/store_item_model.dart';
import 'package:course_app/screens/store/explore_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class StoreTile extends StatelessWidget {
  const StoreTile({super.key, required this.storeItem, required this.index});
  final StoreItemModel storeItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ExploreStoreItem(storeItem: storeItem, index: index));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border:
              Border.all(color: Theme.of(context).cardColor.swatch.shade900),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: 4),
        // height: context.screenHeight * 0.25,
        // width: context.screenWidth * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: '${index}0',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: storeItem.image,
                  // height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 19),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeItem.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          storeItem.category.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      '${storeItem.price} /-',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
