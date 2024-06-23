import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFunctions {
  // fn for fetching courses from Firestore and saving to CourseProvider
}

class MiscFunction {
  static Future<int> generateCourseID() async {
    final counterDB =
        await FirebaseFirestore.instance.collection('admin').doc('db').get();
    int counter = counterDB.data()?['counter'];
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('db')
        .update({'counter': counter + 1});
    return counter;
  }
}
