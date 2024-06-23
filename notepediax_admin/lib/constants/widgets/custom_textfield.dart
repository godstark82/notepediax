import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.onChanged,
      required this.fieldName,
      this.initialValue,
      this.isNumerical});
  final String fieldName;
  String? initialValue;
  bool? isNumerical;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value == '') {
          return 'Please fill this field';
        } else {
          return null;
        }
      },
      onChanged: onChanged,
      keyboardType:
          isNumerical == true ? TextInputType.number : TextInputType.none,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          hintText: fieldName,
          label: Text(fieldName)),
    );
  }
}
