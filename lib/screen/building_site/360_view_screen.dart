import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tripolystudionew/controller/360_view_controller.dart';
import 'package:tripolystudionew/utility/colors.dart';

import '../../common_widget/hotspot_class.dart';
import '../../controller/building_site_controller.dart';
import '../../controller/interior_controller.dart';
import '../../models/interior_model.dart';

class PanoramaScreen extends StatefulWidget {
  final Collection? collection;
  const PanoramaScreen({super.key, this.collection});

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen> {
  final InteriorController interiorController = InteriorController();
  final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());
  final ViewController viewController = Get.put(ViewController());
  List<HotspotPosition>? hotspots;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOrientation();
    });
    _getData();
  }

  _getData() async {
    await ViewController.to.getPlanApiCall({"collection_id": widget.collection?.collectionId});
    ViewController.to.imageUrl.value = widget.collection?.image?.imagePath ?? "";
    await ViewController.to.getHotspotApiCall(widget.collection);
    await ViewController.to.getSiteMusicApiCall(
      widget.collection?.image?.userId.toString(),
      widget.collection?.image?.id,
      widget.collection?.projectId ?? "",
    );

    //for fatch plan Hotspot api call
    await ViewController.to.getPlanHotspotApiCall(ViewController.to.getPlanData.value.planId ?? "");
    hotspots = ViewController.to.getPlanHotspotData.map((e) => HotspotPosition.fromJson(e as Map<String, dynamic>)).toList();
  }

  void _checkOrientation() {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _showRotateDialog();
    }
  }

  void _showRotateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorFFFFFF,
        title: Text('Please Rotate Your Device'),
        content: Text('For the best experience, please rotate your phone to landscape mode.'),
        actions: [
          TextButton(
            onPressed: () {
              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                    Get.back();
                  },
                ),
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? "",
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: colorFFFFFF)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ],
            ),
          ),
          leadingWidth: 255,
        ),
        body: Obx(() {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Obx(() {
                  final imageUrl = ViewController.to.imageUrl.value;
                  if (imageUrl.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(child: CircularProgressIndicator(color: color000000)),
                    );
                  }
                  return FutureBuilder(
                    future: precacheImage(NetworkImage(imageUrl), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Container(
                          color: colorOpi000000,
                          child: const Center(child: CircularProgressIndicator(color: color000000)),
                        );
                      }
                      return PanoramaViewer(
                        animSpeed: 1.0,
                        animReverse: true,
                        interactive: true,
                        hotspots: ViewController.to.hotspotData.map((data) {
                          return Hotspot(
                            latitude: data.pitch ?? 0.0,
                            longitude: data.yaw ?? 0.0,
                            widget: GestureDetector(
                              onTap: () async {
                                ViewController.to.getHotspotImageApiCall(
                                  widget.collection?.collectionId,
                                  data.linkedImageId,
                                  widget.collection?.projectId ?? "",
                                );
                                await ViewController.to.getNewHotspotApiCall(data.linkedImageId);
                                await ViewController.to.getSiteMusicApiCall(
                                  widget.collection?.image?.userId.toString(),
                                  data.linkedImageId,
                                  widget.collection?.projectId ?? "",
                                );
                              },
                              child: Image.asset("assets/icon/full-moon.png", scale: 5),
                            ),
                          );
                        }).toList(),
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    },
                  );
                }),
              ),
              SafeArea(
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(color: colorOpi000000, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset("assets/icon/virtual_reality.png", color: colorFFFFFF, scale: 3),
                        ),
                        // if (ViewController.to.isLoading.value) SizedBox(),
                        // Obx(() {
                        //   if (ViewController.to.isLoading.value) {
                        //     return const SizedBox(height: 40, width: 40, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white));
                        //   }
                        //
                        //
                        //    GestureDetector(
                        //     onTap: () {
                        //       if (ViewController.to.isPlaying.value) {
                        //         ViewController.to.stopMusic();
                        //       } else {
                        //         ViewController.to.playMusic(
                        //           "https://360edgevision.digitaltripolystudio.com/view/fetch_audio_for_image.php?image_id=dWVTNEgvS3lhUEVRT0FGZlowY2dMdz09&project_id=1&user_id=OFpKNnR5V1haMGVwZTY4alJUSWhidz09",
                        //         );
                        //       }
                        //     },
                        //     child: Image.asset(
                        //       ViewController.to.isPlaying.value ? "assets/icon/sound.png" : "assets/icon/sound_off.png",
                        //       color: colorFFFFFF,
                        //       scale: 3,
                        //     ),
                        //   );
                        // }),
                        GestureDetector(
                          onTap: () async {
                            if (ViewController.to.isPlaying.value) {
                              ViewController.to.stopMusic();
                            } else {
                              ViewController.to.playMusic(ViewController.to.musicData.value.audioPath ?? "");
                            }
                          },
                          child: ViewController.to.isLoading.value
                              ? Image.asset(
                                  ViewController.to.isPlaying.value ? "assets/icon/sound.png" : "assets/icon/sound_off.png",
                                  color: colorFFFFFF,
                                  scale: 3,
                                )
                              : Image.asset(
                                  ViewController.to.isPlaying.value ? "assets/icon/sound.png" : "assets/icon/sound_off.png",
                                  color: colorFFFFFF,
                                  scale: 3,
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showPlanWithHotspots(context, ViewController.to.getPlanData.value.image ?? "", hotspots ?? []);
                          },
                          child: Image.asset("assets/icon/building-plan.png", color: colorFFFFFF, scale: 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          );
        }),
      );
    });
  }
}

//
// class HotspotPosition {
//   final int id;
//   final double x; // percentage
//   final double y; // percentage
//   final int linkedImageId;
//
//   HotspotPosition({required this.id, required this.x, required this.y, required this.linkedImageId});
//
//   factory HotspotPosition.fromJson(Map<String, dynamic> json) {
//     return HotspotPosition(
//       id: json['id'],
//       x: json['x'] * 0.01, // convert percentage to 0-1 scale
//       y: json['y'] * 0.01,
//       linkedImageId: json['linked_image_id'],
//     );
//   }
// }
void showPlanWithHotspots(BuildContext context, String imageUrl, List<HotspotPosition> hotspots) {
  showDialog(
    useSafeArea: false,
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: Colors.black,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    backgroundDecoration: const BoxDecoration(color: Colors.black),
                  ),
                  ...hotspots.map((spot) {
                    return Positioned(
                      left: constraints.maxWidth * spot.x,
                      top: constraints.maxHeight * spot.y,
                      child: GestureDetector(
                        onTap: () {
                          Get.snackbar("Hotspot", "Clicked hotspot ${spot.id} → linked ${spot.linkedImageId}");
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.8), shape: BoxShape.circle),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
