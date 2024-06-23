import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({super.key, required this.heading, required this.widget});
  final String heading;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 125,
              child: Text(
            '$heading :',
            maxLines: 2,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: widget,
          )),
        ],
      ),
    );
  }
}
