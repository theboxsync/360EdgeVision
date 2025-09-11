import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';
import '../models/interior_model.dart';

class InteriorController extends GetxController {
  static InteriorController get to => Get.find();

  //for Carousel...............
  var currentIndex = 0.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  //getSite Project Data.................

  RxBool projectInteriorLoader = false.obs;
  Rx<InteriorModel> projectInteriorData = InteriorModel().obs;

  getProjectInteriorApiCall(String? id) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/fetch-interior-collection.php?project_id=$id",
      success: (dio.Response<dynamic> response) {
        print("Success");
        projectInteriorData.value = InteriorModel.fromJson(jsonDecode(response.data));
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: projectInteriorLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
