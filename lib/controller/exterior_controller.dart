import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:tripolystudionew/models/interior_model.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';

class ExteriorController extends GetxController {
  static ExteriorController get to => Get.find();

  //getSite Project Data.................

  RxBool projectExteriorLoader = false.obs;
  Rx<InteriorModel> projectExteriorData = InteriorModel().obs;

  getProjectExteriorApiCall(String? id) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/fetch-exterior-collection.php?project_id=$id",
      success: (dio.Response<dynamic> response) {
        print("Success");
        projectExteriorData.value = InteriorModel.fromJson(jsonDecode(response.data));
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: projectExteriorLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
