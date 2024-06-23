import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/store_item_model.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class ExploreStoreItem extends StatelessWidget {
  const ExploreStoreItem(
      {super.key, required this.storeItem, required this.index});
  final StoreItemModel storeItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: '${index}0',
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(imageUrl: storeItem.image)),
              ),
              SizedBox(height: 25),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(storeItem.title,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(storeItem.category.name.toString(),
                                  style: TextStyle(color: Colors.grey)),
                              Text('Rs. ${storeItem.price}',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ]),
                        SizedBox(height: 20),
                        Text(storeItem.description)
                      ]))
            ],
          )),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: () async {
              await WhatsappShare.share(
                  package: Package.whatsapp,
                  // filePath: [storeItem.image],
                  linkUrl: storeItem.image,
                  phone: "918290519977",
                  text:
                      "Hi, I want to buy the item ${storeItem.title} of Rs. ${storeItem.price} \n");
            },
            child: Text('Buy Now'),
          ),
        ));
  }
}
