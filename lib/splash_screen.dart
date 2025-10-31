import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/utility/colors.dart';
import 'package:tripolystudionew/utility/text_style.dart';

import 'common_widget/tripoly_screen_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color000000,
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: AnimatedTextKit(
                  onFinished: () {
                    Get.offAll(() => TripolyScreenNavigationBar(), transition: Transition.downToUp);
                  },
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 500),
                  animatedTexts: [
                    FadeAnimatedText(
                      "Beyond Vision Into Experience",
                      textAlign: TextAlign.center,
                      textStyle: colorFFFFFFw70030,
                      duration: const Duration(milliseconds: 1500),
                    ),
                    RotateAnimatedText(
                      '360EdgeVision \n by Tripoly Studio',
                      textAlign: TextAlign.center,
                      textStyle: colorFF9800w70030,
                      duration: const Duration(milliseconds: 2000),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
