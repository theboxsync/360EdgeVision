import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  RxList activityName = <String>[].obs;
  RxList navigationScreen = <Widget>[].obs;

  final RxInt selectedIndex = (-1).obs;
  final RxInt projectID = 0.obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }

  void closeDrawer() {
    drawerKey.currentState?.closeDrawer();
  }

  bool isDrawerOpen() {
    return drawerKey.currentState?.isDrawerOpen ?? false;
  }
}
