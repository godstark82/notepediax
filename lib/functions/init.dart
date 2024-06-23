import 'package:course_app/constants/db.dart';
import 'package:hive/hive.dart';

class InitClass {
  static Future<void> init() async {
    DatabaseClass.isLogined = Hive.box('cache').get('isLogined') ?? false;
    DatabaseClass.uid = Hive.box('cache').get('uid') ?? 'N/A';

    // fetching data

  }
}
