// import 'dart:async';
//
// import 'package:get/get.dart';
//
// import '../common_widget/hotspot_class.dart';
//
// class VrController extends GetxController {
//   static VrController get to => Get.find();
//
//   var imageUrl = "".obs; // current panorama image
//   var hotspotData = <HotspotPosition>[].obs;
//
//   var currentYaw = 0.0.obs;
//   var currentPitch = 0.0.obs;
//
//   Timer? hotspotTimer;
//
//   /// Call this when initializing
//   void setInitialImage(String url) {
//     imageUrl.value = url;
//   }
//
//   /// Update current view position (called from PanoramaViewer onViewChanged)
//   void updateViewPosition(double yaw, double pitch) {
//     currentYaw.value = yaw;
//     currentPitch.value = pitch;
//     _checkHotspotMatch();
//   }
//
//   /// Match with hotspots
//   void _checkHotspotMatch() {
//     for (var hotspot in hotspotData) {
//       if ((currentYaw.value - (hotspot.yaw ?? 0)).abs() < 3 && // yaw tolerance
//           (currentPitch.value - (hotspot.pitch ?? 0)).abs() < 3) {
//         // pitch tolerance
//
//         // If already running a timer, skip
//         if (hotspotTimer != null) return;
//
//         hotspotTimer = Timer(const Duration(seconds: 2), () async {
//           // Example: directly change image (you can call API here too)
//           imageUrl.value = "https://360edgevision.digitaltripolystudio.com/admin/my-media/upload/1/gallery/img_6862badd7bc03.webp";
//
//           hotspotTimer = null;
//         });
//       }
//     }
//   }
// }
