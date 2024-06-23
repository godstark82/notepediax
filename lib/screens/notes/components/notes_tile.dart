// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/models/notes_model.dart';
import 'package:course_app/provider/notes_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/course/explore_course.dart';
import 'package:course_app/screens/notes/components/confirm_purchase_notes.dart';
import 'package:course_app/screens/notes/components/explore_notes.dart';
import 'package:course_app/screens/notes/notes_screen.dart';
import 'package:course_app/screens/views/confirm_purchase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class NotesTile extends StatelessWidget {
  const NotesTile({super.key, required this.notes});
  final NotesModel notes;

  @override
  Widget build(BuildContext context) {
    final price = notes.price;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 0),
                blurRadius: 2,
                color: Colors.grey,
                blurStyle: BlurStyle.solid),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 5,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(notes.title,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text(notes.category.name.toString())
                    ])),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 75,
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: notes.image.url,
                          // height: 100,
                          fit: BoxFit.cover,
                        ),
                      )),
                ))
          ]),
          SizedBox(
            child: Text('Rs. $price /-',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.green)),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() =>
                      ExploreNotesScreen(notes: notes, isPurchased: false));
                },
                child: Container(
                    height: 50,
                    width: context.width * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurpleAccent.withOpacity(0.2)),
                    child: Center(
                        child: Text('EXPLORE',
                            style: TextStyle(color: Colors.deepPurple)))),
              ),
              InkWell(
                onTap: () async {
                  await Get.to<bool>(() => ConfirmNotesPurchase(notes: notes));
                  notesList.clear();
                },
                child: Container(
                    height: 50,
                    width: context.width * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurpleAccent),
                    child: Center(
                        child: Text('BUY NOW',
                            style: TextStyle(color: Colors.white)))),
              )
            ],
          )
        ],
      ),
    );
  }
}
