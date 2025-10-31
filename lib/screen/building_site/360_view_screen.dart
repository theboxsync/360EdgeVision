import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:tripolystudionew/controller/360_view_controller.dart';
import 'package:tripolystudionew/models/plan_hotspot_model.dart';
import 'package:tripolystudionew/screen/building_site/vr_screen.dart';
import 'package:tripolystudionew/utility/colors.dart';
import 'package:tripolystudionew/utility/text_style.dart';

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
  ui.Image? _image;
  String? imageUrl;

  Future<void> _loadImage(ImageProvider provider) async {
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);

    final img = await completer.future;
    setState(() => _image = img);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOrientation();
    });
    _getData();
  }

  _getData() async {
    print(widget.collection?.collectionId);
    await ViewController.to.getPlanApiCall({"collection_id": widget.collection?.collectionId});
    imageUrl = ViewController.to.getPlanData.value.image;
    print("Image URL: $imageUrl");

    ViewController.to.imageUrl.value = widget.collection?.image?.imagePath ?? "";

    await ViewController.to.getHotspotApiCall(widget.collection);
    await ViewController.to.getSiteMusicApiCall(
      widget.collection?.image?.userId.toString(),
      widget.collection?.image?.id,
      widget.collection?.projectId ?? "",
    );

    _loadImage(NetworkImage(imageUrl.toString()));
  }

  void _checkOrientation() {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _showRotateDialog();
    }
  }

  void _showRotateDialog() {
    showDialog(
      barrierDismissible: false,
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
            child: Text('OK', style: colorFF9800w40015),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() {
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
                                  print(widget.collection?.projectId ?? "");
                                  ViewController.to.getHotspotImageApiCall(
                                    widget.collection?.collectionId,
                                    data.linkedImageId.toString(),
                                    widget.collection?.projectId ?? "",
                                  );
                                  await ViewController.to.getNewHotspotApiCall(data.linkedImageId.toString());
                                  await ViewController.to.getSiteMusicApiCall(
                                    widget.collection?.image?.userId.toString(),
                                    data.linkedImageId.toString(),
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
                            onTap: () {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
                              Get.to(() => VrScreen(collection: widget.collection));
                            },
                            child: Image.asset("assets/icon/virtual_reality.png", color: colorFFFFFF, scale: 3),
                          ),
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
                            onTap: () async {
                              await ViewController.to.getPlanHotspotApiCall((ViewController.to.getPlanData.value.planId ?? "").toString());
                              final hotspots = ViewController.to.getPlanHotspotData.value
                                  .map((e) => PlanHotspotModel(id: e.id, x: e.x, y: e.y, linkedImageId: e.linkedImageId))
                                  .toList();

                              showPlanWithHotspots(context, imageUrl.toString(), hotspots);
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
      }),
    );
  }

  void showPlanWithHotspots(BuildContext context, String imageUrl, List<PlanHotspotModel> hotspots) async {
    if (_image == null) return;

    final imageAspect = _image!.width / _image!.height;

    showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: true,
      builder: (context) {
        final TransformationController _controller = TransformationController();

        return Center(
          child: AspectRatio(
            aspectRatio: imageAspect,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                final imageAspect = _image!.width / _image!.height;
                final widgetAspect = size.width / size.height;

                late Rect dst;
                if (imageAspect > widgetAspect) {
                  final renderWidth = size.width;
                  final renderHeight = renderWidth / imageAspect;
                  final dy = (size.height - renderHeight) / 2;
                  dst = Rect.fromLTWH(0, dy, renderWidth, renderHeight);
                } else {
                  final renderHeight = size.height;
                  final renderWidth = renderHeight * imageAspect;
                  final dx = (size.width - renderWidth) / 2;
                  dst = Rect.fromLTWH(dx, 0, renderWidth, renderHeight);
                }

                return GestureDetector(
                  onTapUp: (details) {
                    final tapLocal = _controller.toScene(details.localPosition);

                    const double tapRadius = 20.0;

                    for (final spot in hotspots) {
                      final dx = dst.left + dst.width * ((spot.x ?? 0.0) / 100.0);
                      final dy = dst.top + dst.height * ((spot.y ?? 0.0) / 100.0);
                      final hotspotOffset = Offset(dx, dy);

                      if ((tapLocal - hotspotOffset).distance <= tapRadius) {
                        ViewController.to.getHotspotImageApiCall(
                          widget.collection?.collectionId,
                          spot.linkedImageId,
                          widget.collection?.projectId ?? "",
                        );
                        Get.back();
                        debugPrint("Hotspot tapped: ${spot.id}");
                        break;
                      }
                    }
                  },
                  child: InteractiveViewer(
                    transformationController: _controller,
                    minScale: 1.0,
                    maxScale: 5.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: CustomPaint(
                      painter: _ImageHotspotPainter(image: _image!, hotspots: hotspots),
                      size: const Size(double.infinity, double.infinity),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ImageHotspotPainter extends CustomPainter {
  final ui.Image image;
  final List<PlanHotspotModel> hotspots;

  _ImageHotspotPainter({required this.image, required this.hotspots});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final circlePaint = Paint()..color = Colors.redAccent;

    final imageAspect = image.width / image.height;
    final widgetAspect = size.width / size.height;

    late Rect dst;
    if (imageAspect > widgetAspect) {
      final renderWidth = size.width;
      final renderHeight = renderWidth / imageAspect;
      final dy = (size.height - renderHeight) / 2;
      dst = Rect.fromLTWH(0, dy, renderWidth, renderHeight);
    } else {
      final renderHeight = size.height;
      final renderWidth = renderHeight * imageAspect;
      final dx = (size.width - renderWidth) / 2;
      dst = Rect.fromLTWH(dx, 0, renderWidth, renderHeight);
    }

    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(image, src, dst, paint);

    final hotspotOffsets = hotspots.map((spot) {
      final dx = dst.left + dst.width * ((spot.x ?? 0.0) / 100.0);
      final dy = dst.top + dst.height * ((spot.y ?? 0.0) / 100.0);
      return {'offset': Offset(dx, dy), 'id': spot.id};
    }).toList();

    for (final spotData in hotspotOffsets) {
      final offset = spotData['offset'] as Offset;
      final id = spotData['id']?.toString() ?? '';

      canvas.drawCircle(offset, 6.0, circlePaint);

      final tp = TextPainter(
        text: TextSpan(
          text: id,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(offset.dx - tp.width / 2, offset.dy - 20));
    }
  }

  @override
  bool shouldRepaint(covariant _ImageHotspotPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.hotspots != hotspots;
  }
}
