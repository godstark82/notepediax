// ignore_for_file: library_private_types_in_public_api

import 'package:course_app/constants/styles/theme.dart';
import 'package:course_app/firebase_options.dart';
import 'package:course_app/functions/init.dart';
import 'package:course_app/provider/bottom_bar_provider.dart';
import 'package:course_app/provider/carousel_provider.dart';
import 'package:course_app/provider/category_provider.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:course_app/provider/notes_provider.dart';
import 'package:course_app/provider/quiz_provider.dart';
import 'package:course_app/provider/store_provider.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/components/onboarding.dart';
import 'package:course_app/screens/login/login.dart';
import 'package:course_app/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, GoogleAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(
        clientId:
            '499590581626-5vkqnif37pcdtk39em6tevr03d6skte8.apps.googleusercontent.com',
        redirectUri: 'https://courseapp-21eb1.firebaseapp.com/__/auth/handler')
  ]);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await InitClass.init();
  //Remove this method to stop OneSignal Debugging
  // OneSignal.Debug.setLogLevel(OSLogLevel.error);
  OneSignal.initialize("abfbf5a7-d8c8-4dfc-b176-76eb5ff8bf0d");
  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  runApp(ThemeSwitcherWidget(
      initialTheme: MyThemeData.darkTheme, child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseProvider>(create: (_) => CourseProvider()),
        ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider()),
        ChangeNotifierProvider<CarouselProvider>(
            create: (_) => CarouselProvider()),
        ChangeNotifierProvider<BottomBarProvider>(
            create: (_) => BottomBarProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<QuizProvider>(create: (_) => QuizProvider()),
        ChangeNotifierProvider<NotesProvider>(create: (_) => NotesProvider()),
        ChangeNotifierProvider<StoreProvider>(create: (_) => StoreProvider())
      ],
      child: GetMaterialApp(
          defaultTransition: Transition.cupertino,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Notepediax',
          theme: ThemeSwitcher.of(context).themeData,
          darkTheme: ThemeSwitcher.of(context).themeData,
          routes: routes,
          // home: const OnBoarding()),
          initialRoute: Hive.box('cache').get('firstLaunch') == false
              ? (FirebaseAuth.instance.currentUser != null
                  ? '/home'
                  : '/sign-in')
              : '/onboarding'),
    );
  }
}

final routes = {
  '/onboarding': (context) => const OnBoarding(),
  '/sign-in': (context) => const LoginScreen(),
  '/profile': (context) => ProfileScreen(
        showDeleteConfirmationDialog: true,
        appBar: AppBar(title: const Text('Profile'), elevation: 1),
        showUnlinkConfirmationDialog: true,
        actions: [
          SignedOutAction((context) {
            Get.offAllNamed('/sign-in');
          }),
          AccountDeletedAction((context, user) async {
            Get.offAllNamed('/sign-in');
          })
        ],
        children: [
          Text(
            'User uid: ${FirebaseAuth.instance.currentUser?.uid}',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          )
        ],
      ),
  '/home': (context) => const Home(),
  '/forgot-password': (context) => const ForgotPasswordScreen(),
  '/phone': (context) => PhoneInputScreen(
        actions: [
          SMSCodeRequestedAction((context, action, flowKey, phone) {
            Get.toNamed('/sms', arguments: {
              'action': action,
              'flowKey': flowKey,
              'phone': phone,
            });
          })
        ],
      ),
  '/sms': (context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return SMSCodeInputScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Get.offAllNamed('/home');
        })
      ],
      flowKey: arguments?['flowKey'],
      action: arguments?['action'],
    );
  }
};

class ThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher({super.key, required this.data, required super.child});

  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>(
            aspect: ThemeSwitcher))!
        .data;
  }

  @override
  bool updateShouldNotify(ThemeSwitcher oldWidget) {
    return this != oldWidget;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  const ThemeSwitcherWidget(
      {super.key, required this.initialTheme, required this.child});

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData? themeData;

  void switchTheme(ThemeData theme) {
    setState(() {
      themeData = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData ?? widget.initialTheme;
    return ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}
