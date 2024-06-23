// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class DashBoardData {
  static Future<void> totalCoursesSold() async {
    int sold = 0;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('pJvTHQB0OBZRpq1FTwYGvCVdtvC2')
          .get();
      print(querySnapshot.data());
      // return querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching user collection length: $e');
    }
    print(sold);
  }
}
