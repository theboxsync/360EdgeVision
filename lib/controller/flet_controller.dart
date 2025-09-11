import 'package:get/get.dart';

class FletController extends GetxController {
  static FletController get to => Get.find();
  RxList visibleIndexes = [].obs;

  void toggleVisibility(int index) {
    if (visibleIndexes.contains(index)) {
      visibleIndexes.remove(index);
    } else {
      visibleIndexes.add(index);
    }
  }

  bool isVisible(int index) {
    return visibleIndexes.contains(index);
  }
}
