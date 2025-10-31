import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../controller/nav_bar_controller.dart';
import '../screen/tripoly_studio/contact_us_screen.dart';
import '../screen/tripoly_studio/tripoly_studio_screen.dart';
import '../utility/colors.dart';

class TripolyScreenNavigationBar extends StatefulWidget {
  const TripolyScreenNavigationBar({super.key});

  @override
  State<TripolyScreenNavigationBar> createState() => _TripolyScreenNavigationBarState();
}

class _TripolyScreenNavigationBarState extends State<TripolyScreenNavigationBar> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller = PersistentTabController(initialIndex: 0);
    final NavController navController = Get.put(NavController());
    List<Widget> screens = [const TripolyStudioScreen(), const ContactUsScreen()];

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Obx(
            () => Image.asset("assets/icon/home.png", scale: 3, color: NavController.to.selectedIndex.value == 0 ? Color(0xFFFF9800) : Colors.black),
          ),
          //activeColorPrimary: Color(0xFFFF9800),
          //inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Obx(
            () =>
                Image.asset("assets/icon/support.png", scale: 3, color: NavController.to.selectedIndex.value == 1 ? Color(0xFFFF9800) : Colors.black),
          ),
        ),
      ];
    }

    return Scaffold(
      backgroundColor: colorFFFFFF,
      body: PersistentTabView(
        context,
        screens: screens,
        controller: controller,
        items: navBarsItems(),
        navBarHeight: 65,
        navBarStyle: NavBarStyle.style6,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        backgroundColor: colorFFFFFF,
        onItemSelected: (index) {
          NavController.to.changeTab(index);
        },
        decoration: NavBarDecoration(
          colorBehindNavBar: colorFFFFFF,
          border: Border(top: BorderSide(color: colorFF9800)),
        ),
      ),
    );
  }
}
