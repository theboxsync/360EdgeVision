import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:tripolystudionew/models/hotspot_model.dart';
import 'package:tripolystudionew/models/interior_model.dart';

import '../../common_widget/hotspot_class.dart';
import '../../controller/360_view_controller.dart';
import '../../controller/building_site_controller.dart';
import '../../controller/interior_controller.dart';
import '../../utility/colors.dart';

class VrScreen extends StatefulWidget {
  final Collection? collection;
  const VrScreen({super.key, this.collection});

  @override
  State<VrScreen> createState() => _VrScreenState();
}

class _VrScreenState extends State<VrScreen> {
  final InteriorController interiorController = InteriorController();
  final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());
  final ViewController viewController = Get.put(ViewController());
  List<HotspotPosition>? hotspots;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    ViewController.to.imageUrl.value = widget.collection?.image?.imagePath ?? "";
    await ViewController.to.getHotspotApiCall(widget.collection);
  }

  Timer? _focusTimer;
  String? _focusedHotspotId;

  void onViewChange(BuildContext context, double? lon, double? lat, double? tilt) {
    const threshold = 2;

    String? newFocusedHotspotId;
    HotspotModel? focusedHotspot;
    for (final data in ViewController.to.hotspotData) {
      final double pitch = data.pitch ?? 0.0;
      final double yaw = data.yaw ?? 0.0;
      if (((lon ?? 0) - yaw).abs() < threshold && ((lat ?? 0) - pitch).abs() < threshold) {
        newFocusedHotspotId = data.hotspotId.toString();
        focusedHotspot = data;
        break;
      }
    }

    if (newFocusedHotspotId != _focusedHotspotId) {
      _focusTimer?.cancel();
      _focusedHotspotId = newFocusedHotspotId;

      if (_focusedHotspotId != null) {
        _focusTimer = Timer(const Duration(seconds: 1), () async {
          ViewController.to.getHotspotImageApiCall(
            widget.collection?.collectionId,
            focusedHotspot?.linkedImageId ?? "",
            widget.collection?.projectId ?? "",
          );
          await ViewController.to.getNewHotspotApiCall(focusedHotspot?.linkedImageId);
        });
      }
    }
  }

  Widget _buildEye() {
    return Obx(() {
      final imageUrl = ViewController.to.imageUrl.value;
      if (imageUrl.isEmpty) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Center(child: CircularProgressIndicator(color: color000000)),
        );
      }
      return Expanded(
        child: ClipPath(
          clipper: LensClipper(),
          child: FutureBuilder(
            future: precacheImage(NetworkImage(imageUrl), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                  color: colorOpi000000,
                  child: const Center(child: CircularProgressIndicator(color: colorFFFFFF)),
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  PanoramaViewer(
                    animReverse: true,
                    interactive: false,
                    sensitivity: 2.0,
                    sensorControl: SensorControl.orientation,
                    onViewChanged: (lon, lat, tilt) => onViewChange(context, lon, lat, tilt),
                    hotspots: ViewController.to.hotspotData.map((data) {
                      return Hotspot(
                        latitude: data.pitch ?? 0.0,
                        longitude: data.yaw ?? 0.0,
                        widget: GestureDetector(child: Image.asset("assets/icon/full-moon.png", scale: 5)),
                      );
                    }).toList(),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                  Image.asset("assets/icon/circle.png", scale: 3),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Transform.rotate(
                  angle: 45 * 6.1416 / 180,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
                  Get.back();
                },
              ),
            ],
          ),
        ],
        leadingWidth: 255,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(children: [_buildEye(), const SizedBox(height: 10), _buildEye()]),
      ),
    );
  }
}

class LensClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(130)));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
