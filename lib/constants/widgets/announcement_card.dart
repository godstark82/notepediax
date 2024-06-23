// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announment});
  final AnnounmentsModel announment;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).cardColor,
                        // radius: 50,
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        announment.adminName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                          '${announment.time.day} / ${announment.time.month} / ${announment.time.year}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(announment.text),
                    ),
                    if (announment.image != null && announment.image != "")
                      // Divider(),
                    if (announment.image != null && announment.image != "")
                      AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                              imageUrl: announment.image.toString()))
                  ]),
            )));
  }
}
