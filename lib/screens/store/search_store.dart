import 'package:course_app/models/store_item_model.dart';
import 'package:course_app/provider/store_provider.dart';
import 'package:course_app/screens/store/store_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchStorePage extends StatefulWidget {
  const SearchStorePage({super.key});

  @override
  State<SearchStorePage> createState() => _SearchStorePageState();
}

class _SearchStorePageState extends State<SearchStorePage> {
  String query = '';
  // ignore: non_constant_identifier_names
  List<StoreItemModel> storeItems = [];

  void searchQuery() {
    storeItems = context
        .read<StoreProvider>()
        .storeItems
        .where((element) =>
            element.title.toLowerCase() == query.toLowerCase() ||
            element.description.toLowerCase() == query.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Search here'),
                autofocus: true,
                onChanged: (value) {
                  query = value;
                  searchQuery();
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        body: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: storeItems.length,
            itemBuilder: (context, index) => StoreTile(
                  storeItem: storeItems[index],
                  index: index,
                )),
      ),
    );
  }
}
