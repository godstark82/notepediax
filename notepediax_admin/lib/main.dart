import 'package:course_admin/functions/init.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget, WidgetsFlutterBinding, runApp;
import 'package:get/get.dart' show GetMaterialApp;
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;
import 'package:course_admin/constants/const_variable.dart' show AdminDetails;
import 'package:course_admin/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:course_admin/providers/carousel_provider.dart'
    show CarouselProvider;
import 'package:course_admin/providers/category_provider.dart'
    show CategoryProvider;
import 'package:course_admin/providers/course_provider.dart'
    show CourseProvider;
import 'package:course_admin/providers/gallery_provider.dart'
    show GalleryProvider;
import 'package:course_admin/providers/notes_provider.dart';
import 'package:course_admin/providers/quiz_provider.dart';
import 'package:course_admin/providers/store_provider.dart';
import 'package:course_admin/screens/auth/login.dart' show LoginScreen;
import 'package:course_admin/screens/home/home.dart' show Home;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  // await DashBoardData.totalCoursesSold();
  await InitFunctions.init().whenComplete(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GalleryProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => CarouselProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => StoreProvider()),
      ],
      child: GetMaterialApp(
        routes: routes,
        debugShowCheckedModeBanner: false,
        title: 'Notepediax Admin',
        initialRoute: '/',

        // home: ViewCourseScreen(index: 0),
      ),
    );
  }
}

final routes = {
  '/': (context) =>
      AdminDetails.isLogined == true ? const Home() : const LoginScreen(),
  '/Home': (context) => const Home(),
  '/LoginScreen': (context) => const LoginScreen()
};
