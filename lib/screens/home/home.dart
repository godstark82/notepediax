import 'package:awesome_bottom_bar/awesome_bottom_bar.dart'
    show BottomBarCreative, TabItem;
import 'package:course_app/constants/styles/theme.dart';
import 'package:course_app/main.dart';
import 'package:course_app/screens/home/components/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:ionicons/ionicons.dart' show Ionicons;
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/provider/carousel_provider.dart';
import 'package:course_app/provider/category_provider.dart';
import 'package:course_app/provider/store_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/components/drawer.dart';
import 'package:course_app/screens/home/home_screen.dart';
import 'package:course_app/screens/notes/notes_screen.dart';
import 'package:course_app/screens/quiz/quiz_screen.dart';
import 'package:course_app/screens/store/store_screen.dart';
import 'package:course_app/screens/study/study_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: GlobalKeys.homeScaffoldKey,
        appBar: AppBar(
            title: ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, value, child) {
                  if (value == 0) {
                    return Text('Notepediax',
                            style: Theme.of(context).textTheme.titleMedium);
                        
                  }
                  if (value == 1) {
                    return Text('Notes',
                            style: Theme.of(context).textTheme.titleMedium)
                        ;
                  }
                  if (value == 3) {
                    return Text('Quizes',
                            style: Theme.of(context).textTheme.titleMedium)
                       ;
                  } else {
                    return Text('Store',
                            style: Theme.of(context).textTheme.titleMedium)
                        ;
                  }
                }),
            elevation: 2,
            actions: [
              ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, value, child) {
                  if (value == 0) {
                    return IconButton(
                      onPressed: () {
                        // Get.to(() => const SearchBarHomeScreen());
                        Get.to(() => SearchResultPage());
                      },
                      icon: const Icon(
                        Ionicons.search_outline,
                        semanticLabel: 'Search Courses',
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ]),
        drawer: const MyDrawer(),
        body: CustomPaint(
          // painter: MyPainter(),
          child: FutureBuilder(
              future: Future.wait([
                // Courses has been fetched in fetchUserCourses function
                context.read<UserProvider>().fetchUserCourses(context),
                context.read<UserProvider>().fetchUserNotes(context),
                context.read<UserProvider>().fetchUserQuizes(context),
          
                context.read<CarouselProvider>().fetchCarousel(),
                context.read<CategoryProvider>().fetchCategories(),
          
                // context.read<NotesProvider>().fetchNotes(),
                context.read<StoreProvider>().fetchStore(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    child: ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (context, value, child) {
                        return screens[value];
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Skeletonizer(
                    enabled: false,
                    child: ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (context, value, child) {
                        return screens[value];
                      },
                    ),
                  );
                }
              }),
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, value, child) {
              return BottomBarCreative(
                  boxShadow: const [
                    BoxShadow(blurRadius: 1, color: Colors.grey)
                  ],
                  enableShadow: true,
                  isFloating: true,

                  // backgroundSelected: Colors.red,
                  // animated: true,
                  items: items,
                  
                  backgroundColor: ThemeSwitcher.of(context).themeData == MyThemeData.darkTheme ? Color.fromARGB(255, 8, 20, 28):Colors.white,
                  color: Colors.grey,
                  colorSelected: Colors.blue,
                  indexSelected: value,
                  onTap: (newIndex) async {
                    if (newIndex == 2) {
                      await Get.to(() => const StudyScreen());
                      selectedIndex.value = 0;
                    } else {
                      selectedIndex.value = newIndex;
                    }
                  });
            }));
  }

  List<Widget> screens = <Widget>[
    const HomeScreen(),
    const NotesScreen(),
    const StudyScreen(),
    const QuizScreen(),
    const StoreScreen()
  ];

  List<TabItem> items = [
    const TabItem(
      icon: Ionicons.home_outline,
      title: 'Home',
    ),
    const TabItem(
      icon: Ionicons.tablet_landscape_outline,
      title: 'Notes',
    ),
    const TabItem(
      icon: Ionicons.book_outline,
      title: 'Study',
    ),
    const TabItem(
      icon: Ionicons.bulb_outline,
      title: 'Quiz',
    ),
    const TabItem(
      icon: Ionicons.storefront_outline,
      title: 'Store',
    ),
  ];
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

ValueNotifier<int> selectedIndex = ValueNotifier(0);


// Home
// Courses
/* Quiz
   Notes
   Store
 */
