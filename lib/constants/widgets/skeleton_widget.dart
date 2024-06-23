import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(index.toString()),
              title: const Text('MyData Title'),
              subtitle: const Text('Subtitle'),
              isThreeLine: true,
              trailing: const Icon(Icons.add),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 15),
    ));
  }
}
