import 'package:get/get.dart';

class NavController extends GetxController {
  static NavController get to => Get.find();
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
