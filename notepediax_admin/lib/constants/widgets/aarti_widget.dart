import 'package:flutter/material.dart';

class AartiWidget extends StatelessWidget {
  const AartiWidget({
    super.key,
    required this.name,
    required this.list,
  });
  final String name;
  final List list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index].toString()),
            );
          }),
    );
  }
}


