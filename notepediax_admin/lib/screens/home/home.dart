import 'package:course_admin/constants/styles/colors.dart';
import 'package:course_admin/providers/carousel_provider.dart';
import 'package:course_admin/providers/category_provider.dart';
import 'package:course_admin/providers/course_provider.dart';
import 'package:course_admin/providers/gallery_provider.dart';
import 'package:course_admin/providers/notes_provider.dart';
import 'package:course_admin/providers/quiz_provider.dart';
import 'package:course_admin/providers/store_provider.dart';
import 'package:course_admin/screens/carousel/carousel_screen.dart';
import 'package:course_admin/screens/category/category_screen.dart';
import 'package:course_admin/screens/gallery/gallery_screen.dart';
import 'package:course_admin/screens/home/course_screen.dart';
import 'package:course_admin/screens/notes/notes_screen.dart';
import 'package:course_admin/screens/quiz/quiz_screen.dart';
import 'package:course_admin/screens/shop/shop_screen.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static SideMenuController sideMenu = SideMenuController();
  PageController pageController = PageController();

  // List of side menu items
  List<SideMenuItem> sideItems(BuildContext context) {
    return [
      SideMenuItem(
        title: 'Courses',
        tooltipContent: 'Courses',
        trailing: CircleAvatar(
            child:
                Text('${context.read<CourseProvider>().courses.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.dashboard_sharp),
      ),
      SideMenuItem(
        tooltipContent: 'Category',
        title: 'Category',
        trailing: CircleAvatar(
            child:
                Text('${context.read<CategoryProvider>().categories.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.golf_course),
      ),
      SideMenuItem(
        title: 'Carousel',
        tooltipContent: 'Carousel',
        trailing: CircleAvatar(
            child:
                Text('${context.read<CarouselProvider>().carousels.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.slideshow_outlined),
      ),
      SideMenuItem(
        title: 'Quizes',
        tooltipContent: 'Quizes',
        trailing: CircleAvatar(
            child:
                Text('${context.read<QuizProvider>().quizes.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.bubble_chart),
      ),
      SideMenuItem(
        title: 'Notes',
        tooltipContent: 'Notes',
        trailing: CircleAvatar(
            child:
                Text('${context.read<NotesProvider>().notes.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.book),
      ),
      SideMenuItem(
        title: 'Shop Items',
        tooltipContent: 'Store Items',
        trailing: CircleAvatar(
            child:
                Text('${context.read<StoreProvider>().storeItems.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.store),
      ),
      SideMenuItem(
        title: 'Gallery',
        tooltipContent: 'Gallery',
        trailing: CircleAvatar(
            child:
                Text('${context.read<GalleryProvider>().gallery.length}')),
        onTap: (index, _) {
          _.changePage(index);
        },
        icon: const Icon(Icons.image),
      ),
    ];
  }

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          // context.read<CourseProvider>().fetchCourses(),
          context.read<QuizProvider>().fetchQuizes(),
          context.read<CategoryProvider>().fetchCategories(),
          context.read<GalleryProvider>().fetchGallery(),
          context.read<NotesProvider>().fetchNotes(),
          context.read<StoreProvider>().fetchStore(),
        ]),
        builder: (context, snapshot) {
          return Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SideMenu(
                  style: SideMenuStyle(
                    backgroundColor: AppColors.greyColor,
                    hoverColor: AppColors.blackColor.withOpacity(0.1),
                    selectedColor: AppColors.purpleColor,
                    showTooltip: true,
                  ),
                  showToggle: true,
                  // Page controller to manage a PageView
                  controller: sideMenu,
                  // Will shows on top of all items, it can be a logo or a Title text
                  title: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.dashboard),
                            SizedBox(width: 10),
                            Text('Notepediax Admin')
                          ])),
                  footer: const Text('Made by venom82'),
                  onDisplayModeChanged: (mode) {},
                  items: sideItems(context),
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: const [
                      CourseScreen(),
                      CategoryScreen(),
                      CarouselScreen(),
                      QuizScreen(),
                      NotesScreen(),
                      ShopScreen(),
                      GalleryScreen(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
