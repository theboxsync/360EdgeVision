import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';
import '../models/building_site_model.dart';

class BuildingSiteController extends GetxController {
  static BuildingSiteController get to => Get.find();

  RxBool showAll = false.obs;
  RxBool siteFeaturesAll = false.obs;

  RxInt categories = 0.obs;
  RxBool buildingSiteLoader = false.obs;
  Rx<BuildingSiteModel> buildingSiteData = BuildingSiteModel().obs;

  getBuildingSiteApiCall(String? id) async {
    String url = "https://360edgevision.digitaltripolystudio.com/fetch_project_data.php?project_id=$id";
    await apiServiceCall(
      params: {},
      serviceUrl: url,
      success: (dio.Response<dynamic> response) {
        print("Success");
        buildingSiteData.value = BuildingSiteModel.fromJson(jsonDecode(response.data));
        print(response.data);
        // var jsonList = jsonDecode(response.data) as List;
        // siteProjectData.value = jsonList.map((item) => SiteProjectModel.fromJson(item as Map<String, dynamic>)).toList();
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: buildingSiteLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
