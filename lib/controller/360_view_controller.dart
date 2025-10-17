import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:tripolystudionew/common_widget/hotspot_class.dart';
import 'package:tripolystudionew/models/interior_model.dart';
import 'package:tripolystudionew/models/music_model.dart';

import '../api_call/api_config.dart';
import '../api_call/api_service.dart';
import '../models/hotspot_image_model.dart';
import '../models/hotspot_model.dart';
import '../models/plan_fatch_model.dart';

class ViewController extends GetxController {
  static ViewController get to => Get.find();

  RxBool isInitialLoading = false.obs;

  //getSite Project Data.................
  /// Observable image URL
  RxString imageUrl = "".obs;

  /// Change image on hotspot tap
  void changeImage(String newUrl) {
    imageUrl.value = newUrl;
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxBool isLoading = false.obs;

  Future<void> playMusic(String url) async {
    try {
      isLoading.value = true;
      await _audioPlayer.play(UrlSource(url));
      isPlaying.value = true;
    } catch (e) {
      print("Error playing audio: $e");
    } finally {
      isLoading.value = false; // stop loading
    }
  }

  Future<void> stopMusic() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      isLoading.value = false;
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  RxBool getPlanLoader = false.obs;
  Rx<PlanFetchModel> getPlanData = PlanFetchModel().obs;

  getPlanApiCall(Map<String, dynamic> collectionData) async {
    final formData = dio.FormData.fromMap(collectionData);

    await apiServiceCall(
      params: {},
      formValues: formData,
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/view/fetch-plan.php",
      success: (dio.Response<dynamic> response) {
        print("Success");
        getPlanData.value = PlanFetchModel.fromJson(jsonDecode(response.data));
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: getPlanLoader,
      methodType: ApiConfig.methodPOST,
    );
  }

  RxBool hotspotLoader = false.obs;
  final RxList<HotspotModel> hotspotData = <HotspotModel>[].obs;

  getHotspotApiCall(Collection? collectionData) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/view/fetch_hotspots.php?image_id=${collectionData?.image?.id}",
      success: (dio.Response<dynamic> response) {
        print("Success");
        hotspotData.value = (jsonDecode(response.data) as List).map((e) => HotspotModel.fromJson(e)).toList();
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: hotspotLoader,
      methodType: ApiConfig.methodGET,
    );
  }

  RxBool getPlanHotspotLoader = false.obs;
  final RxList<HotspotModel> getPlanHotspotData = <HotspotModel>[].obs;
  final RxList<HotspotPosition> getPlanHotspotDataList = <HotspotPosition>[].obs;

  getPlanHotspotApiCall(String? planId) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/view/fetch_plan_hotspots.php?plan_id=$planId",
      success: (dio.Response<dynamic> response) {
        print("Success");
        print(response.data);
        getPlanHotspotData.value = (jsonDecode(response.data) as List).map((e) => HotspotModel.fromJson(e)).toList();
        print(getPlanHotspotData);
        print("hello.........");
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: getPlanHotspotLoader,
      methodType: ApiConfig.methodGET,
    );
  }

  RxBool newHotspotLoader = false.obs;

  getNewHotspotApiCall(String? imageId) async {
    await apiServiceCall(
      params: {},
      serviceUrl: "https://360edgevision.digitaltripolystudio.com/view/fetch_hotspots.php?image_id=$imageId",
      success: (dio.Response<dynamic> response) {
        print("Success");
        hotspotData.value = (jsonDecode(response.data) as List).map((e) => HotspotModel.fromJson(e)).toList();
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: hotspotLoader,
      methodType: ApiConfig.methodGET,
    );
  }

  RxBool hotspotImageLoader = false.obs;
  Rx<HotspotImageModel> hotspotImageData = HotspotImageModel().obs;

  getHotspotImageApiCall(String? collectionId, String? imageId, String projectId) async {
    await apiServiceCall(
      params: {},
      serviceUrl:
          "https://360edgevision.digitaltripolystudio.com/view/fetch_image.php?image_id=$imageId&collection_id=$collectionId&project_id=$projectId",
      success: (dio.Response<dynamic> response) async {
        print("Success");
        hotspotImageData.value = HotspotImageModel.fromJson(jsonDecode(response.data));
        if (hotspotImageData.value.imagePath != null) {
          changeImage(hotspotImageData.value.imagePath!);
        }
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: hotspotImageLoader,
      methodType: ApiConfig.methodGET,
    );
  }

  RxBool musicLoader = false.obs;
  Rx<MusicModel> musicData = MusicModel().obs;

  getSiteMusicApiCall(String? userId, String? imageId, String? projectId) async {
    await apiServiceCall(
      params: {},
      serviceUrl:
          "https://360edgevision.digitaltripolystudio.com/view/fetch_audio_for_image.php?image_id=$imageId&project_id=$projectId&user_id=$userId",
      success: (dio.Response<dynamic> response) {
        print("Success");
        musicData.value = MusicModel.fromJson(jsonDecode(response.data));
        // changeImage()
        print(response.data);
      },
      error: (dio.Response<dynamic> response) {},
      isStopAction: true.obs,
      isLoading: musicLoader,
      methodType: ApiConfig.methodGET,
    );
  }
}
