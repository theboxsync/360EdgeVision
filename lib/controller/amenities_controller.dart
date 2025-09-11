import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:tripolystudionew/models/interior_model.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';

class AmenitiesController extends GetxController {
  static AmenitiesController get to => Get.find();

  //getSite Project Data.................

  RxBool projectAmenitiesLoader = false.obs;
  Rx<InteriorModel> projectAmenitiesData = InteriorModel().obs;

  getProjectAmenitiesApiCall(String? id) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/fetch-amenities-collection.php?project_id=$id",
      success: (dio.Response<dynamic> response) {
        print("Success");
        projectAmenitiesData.value = InteriorModel.fromJson(jsonDecode(response.data));
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: projectAmenitiesLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
