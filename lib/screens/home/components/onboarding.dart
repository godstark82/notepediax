import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: const Color.fromARGB(255, 136, 216, 223),
        finishButtonText: 'Register',

        pageBackgroundColor: const Color.fromARGB(255, 136, 216, 223),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: const Text('Notepediax')
        ),
        onFinish: () async {
          await Hive.box('cache').put('firstLaunch', false);
          Get.offAllNamed('/sign-in');
        },
        // centerBackground: true,
        finishButtonStyle:
            const FinishButtonStyle(backgroundColor: Colors.black),
        skipTextButton: const Text('Skip'),
        trailing: const SizedBox(),
        background: [
          Image.asset('assets/images/slide_1.png'),
          Image.asset('assets/images/slide_2.png'),
          Image.asset('assets/images/slide_3.png'),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Notepediax',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Row(
              children: <Widget>[
                // SizedBox(
                //   height: 480,
                // ),
                Text('Notepediax',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Row(
              children: <Widget>[
                // SizedBox(
                //   height: 480,
                // ),
                Text('Notepediax',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
