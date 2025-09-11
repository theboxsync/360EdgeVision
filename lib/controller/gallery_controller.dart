import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:tripolystudionew/models/gallery_model.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';

class GalleryController extends GetxController {
  static GalleryController get to => Get.find();

  RxList? categories = ["All", "Exterior", "Interior"].obs;
  var selectedCategory = RxnString();

  //getSite Project Data.................

  RxBool galleryLoader = false.obs;
  Rx<GalleryModel> galleryData = GalleryModel().obs;

  getGalleryApiCall(String? id, [String? type]) async {
    String url = "https://360edgevision.digitaltripolystudio.com/fetch_gallery.php?project_id=$id";
    if (type != null) {
      url += "&type=$type";
    }
    await apiServiceCall(
      params: {},
      serviceUrl: url,
      success: (dio.Response<dynamic> response) {
        print("Success");
        galleryData.value = GalleryModel.fromJson(jsonDecode(response.data));
        print(response.data);
        // var jsonList = jsonDecode(response.data) as List;
        // siteProjectData.value = jsonList.map((item) => SiteProjectModel.fromJson(item as Map<String, dynamic>)).toList();
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: galleryLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
