import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/splash_screen.dart';
import 'package:tripolystudionew/utility/colors.dart';

import 'controller/drawer_controller.dart';

// final GetStorage getPreference = GetStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();
  Get.put(BottomNavigationController(), permanent: true);
  runApp(
    //DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: colorFFFFFF, elevation: 0, shadowColor: Colors.transparent, surfaceTintColor: Colors.transparent),
      ),
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
