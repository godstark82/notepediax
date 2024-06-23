import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:course_app/constants/widgets/purchased_course_tile.dart';
import 'package:course_app/provider/user_provider.dart';

class UserCourses extends StatelessWidget {
  const UserCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 150),
          child: Container(
            height: 160,
            decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.deepPurple,
                            size: 18,
                          )),
                        ))),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16),
                  child: Text(
                    'COURSES',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: context.read<UserProvider>().fetchUserCourses(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator()
              );
            }
            return context.watch<UserProvider>().userCourses.isEmpty
                ? Center(
                    child: EmptyWidget(
                      packageImage: PackageImage.Image_1,
                      title: 'No Course Found',
                      hideBackgroundAnimation: true,
                      subTitle: '',
                    ),
                  )
                : CustomScrollView(slivers: [
                    SliverList.builder(
                        itemCount:
                            context.read<UserProvider>().userCourses.length,
                        itemBuilder: (context, index) {
                          return PurchasedCourseTile(
                            course:
                                context.read<UserProvider>().userCourses[index],
                          );
                        })
                  ]);
          },
        ));
  }
}
