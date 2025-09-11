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
            () => Image.asset("assets/icon/home.png", scale: 5, color: NavController.to.selectedIndex.value == 0 ? Color(0xFFFF9800) : Colors.black),
          ),
          //activeColorPrimary: Color(0xFFFF9800),
          //inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Obx(
            () => Image.asset(
              "assets/icon/contect_us.png",
              scale: 5,
              color: NavController.to.selectedIndex.value == 1 ? Color(0xFFFF9800) : Colors.black,
            ),
          ),
          //activeColorPrimary: Color(0xFFFF9800),
          // inactiveColorPrimary: Colors.black,
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
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //boxShadow: [BoxShadow(color: colorF8D691, blurRadius: 10, offset: Offset(0, -1))],
        ),
      ),
    );
  }
}
