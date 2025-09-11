import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';
import '../models/site_project_model.dart';

class SiteProjectController extends GetxController {
  static SiteProjectController get to => Get.find();

  // tripoly Studio screen for Carousel...............
  var tripolyCurrentIndex = 0.obs;

  void tripolyUpdateIndex(int index) {
    tripolyCurrentIndex.value = index;
  }

  // Interior Studio screen for Carousel...............
  var interiorCurrentIndex = 0.obs;

  void interiorUpdateIndex(int index) {
    interiorCurrentIndex.value = index;
  }

  // exterior Studio screen for Carousel...............
  var exteriorCurrentIndex = 0.obs;

  void exteriorUpdateIndex(int index) {
    exteriorCurrentIndex.value = index;
  }

  // AMENITIES Studio screen for Carousel...............
  var amenitiesCurrentIndex = 0.obs;

  void amenitiesUpdateIndex(int index) {
    amenitiesCurrentIndex.value = index;
  }

  //getSite Project Data.................

  RxBool siteProjectLoader = false.obs;
  RxList<SiteProjectModel> siteProjectData = <SiteProjectModel>[].obs;

  getSiteProjectApiCall() async {
    await apiServiceCall(
      params: {},
      serviceUrl: ApiConfig.getProjects,
      success: (dio.Response<dynamic> response) {
        print("Success");
        var jsonList = jsonDecode(response.data) as List;
        siteProjectData.value = jsonList.map((item) => SiteProjectModel.fromJson(item as Map<String, dynamic>)).toList();
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: siteProjectLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
