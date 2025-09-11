import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:tripolystudionew/models/plan_model.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';

class PlanController extends GetxController {
  static PlanController get to => Get.find();

  RxList? categories = ["All", "Exterior", "Interior"].obs;
  var selectedCategory = RxnString();

  //getSite Project Data.................

  RxBool planLoader = false.obs;
  Rx<PlanModel> planData = PlanModel().obs;

  getPlanApiCall(String? id) async {
    String url = "https://360edgevision.digitaltripolystudio.com/fetch-plan.php?project_id=$id";
    await apiServiceCall(
      params: {},
      serviceUrl: url,
      success: (dio.Response<dynamic> response) {
        print("Success");
        planData.value = PlanModel.fromJson(jsonDecode(response.data));
        print(response.data);
        // var jsonList = jsonDecode(response.data) as List;
        // siteProjectData.value = jsonList.map((item) => SiteProjectModel.fromJson(item as Map<String, dynamic>)).toList();
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: planLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
