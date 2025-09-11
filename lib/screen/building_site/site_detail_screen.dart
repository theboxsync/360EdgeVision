import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripolystudionew/common_widget/common_app_bar.dart';
import 'package:tripolystudionew/models/site_project_model.dart';
import 'package:tripolystudionew/screen/building_site/site_amenities_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/common_button.dart';
import '../../controller/building_site_controller.dart';
import '../../controller/drawer_controller.dart';
import '../../controller/flet_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';
import 'exterior_detail_screen.dart';
import 'interior_detail_screen.dart';

class SiteDetailScreen extends StatefulWidget {
  final SiteProjectModel? projectDetails;
  const SiteDetailScreen({super.key, this.projectDetails});

  @override
  State<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  GoogleMapController? _controller;
  LatLng? location;
  final List<String> featuresList = ["Structure", "Flooring", "Door & Window", "Toilet", "Electricification", "Colour", "Water Proofing", "General"];
  final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());
  final FletController fletController = Get.put(FletController());
  LatLng? latLng;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BottomNavigationController.to.activityName.clear();
    BottomNavigationController.to.navigationScreen.clear();
    _getData();
  }

  LatLng? extractLatLngFromEmbedUrl(String url) {
    try {
      final regexLon = RegExp(r'!2d([0-9.\-]+)');
      final regexLat = RegExp(r'!3d([0-9.\-]+)');

      final lonMatch = regexLon.firstMatch(url);
      final latMatch = regexLat.firstMatch(url);

      if (lonMatch != null && latMatch != null) {
        final lon = double.parse(lonMatch.group(1)!);
        final lat = double.parse(latMatch.group(1)!);
        return LatLng(lat, lon);
      }
    } catch (e) {
      print("Error extracting LatLng: $e");
    }
    return null;
  }

  _getData() async {
    await BuildingSiteController.to.getBuildingSiteApiCall(widget.projectDetails?.projectId);
    latLng = extractLatLngFromEmbedUrl(BuildingSiteController.to.buildingSiteData.value.about?.googleLink ?? "");
    _markers.add(
      Marker(
        markerId: const MarkerId("site_marker"),
        position: latLng!,
        infoWindow: InfoWindow(title: BuildingSiteController.to.buildingSiteData.value.project?.name ?? ""),
      ),
    );
    if (BuildingSiteController.to.buildingSiteData.value.categories?.hasInterior == true) {
      BottomNavigationController.to.activityName.add("Interior");
      BottomNavigationController.to.navigationScreen.add(InteriorDetailScreen(projectDetail: widget.projectDetails));
    }
    if (BuildingSiteController.to.buildingSiteData.value.categories?.hasExterior == true) {
      BottomNavigationController.to.activityName.add("Exterior");
      BottomNavigationController.to.navigationScreen.add(ExteriorDetailScreen(projectDetail: widget.projectDetails));
    }
    if (BuildingSiteController.to.buildingSiteData.value.categories?.hasAmenities == true) {
      BottomNavigationController.to.activityName.add("Amenities");
      BottomNavigationController.to.navigationScreen.add(SiteAmenitiesScreen(projectDetail: widget.projectDetails));
    }
  }

  @override
  Widget build(BuildContext context) {
    //final List<String> displayedItems = featuresList.take(6).toList();
    return Obx(() {
      return Scaffold(
        backgroundColor: colorFFFFFF,
        appBar: commonAppBar(logoUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? ""),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Obx(() {
              if (BuildingSiteController.to.buildingSiteLoader == true) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(color: color000000, borderRadius: BorderRadius.all(Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: BuildingSiteController.to.buildingSiteData.value.gallery?[0].imageUrl ?? "",
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.black)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'CLIENT : ', style: color808080w40015),
                                          TextSpan(
                                            text: BuildingSiteController.to.buildingSiteData.value.about?.clientName ?? "",
                                            style: color000000w40015,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'YEAR : ', style: color808080w40015),
                                          TextSpan(
                                            text: BuildingSiteController.to.buildingSiteData.value.about?.projectYear,
                                            style: color000000w40015,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'PROJECT TYPE : ', style: color808080w40015),
                                      TextSpan(text: BuildingSiteController.to.buildingSiteData.value.about?.projectType, style: color000000w40015),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: color808080, endIndent: 10, indent: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              BuildingSiteController.to.buildingSiteData.value.aboutHeader?.header ?? "",
                              textAlign: TextAlign.center,
                              style: color000000w60025,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  BuildingSiteController.to.buildingSiteData.value.aboutHeader?.descriptions?[0].paragraph ?? "",
                                  style: color808080w40015,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: colorEEEEEE),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Stand out with cutting-edge 360°, AR & VR solutions that let your audience explore, interact, and believe in your vision.",
                              textAlign: TextAlign.center,
                              style: color808080w40015,
                            ),
                            SizedBox(height: 20),
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Explore', style: color000000w60025),
                                  TextSpan(text: " the World", style: color000000w40025),
                                  TextSpan(text: ' Through Our ', style: color000000w60025),
                                  TextSpan(text: "360°, AR/VR", style: color000000w40025),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            // SizedBox(height: 20),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 30),
                            //   child: CommonButton(
                            //     isLoading: false,
                            //     title: "View More",
                            //     onPressed: () {
                            //       Get.to(() => InteriorDetailScreen(projectDetail: widget.projectDetails));
                            //     },
                            //   ),
                            // ),
                            // SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                      child: Text("Our Approach to Quality & Detailing", textAlign: TextAlign.center, style: color000000w60020),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Every project we undertake is crafted with a focus on long-lasting quality, thoughtful design, and premium specifications. From robust structural integrity to elegant finishes, we ensure each detail reflects excellence. Our material choices, workmanship, and technical installations are carefully curated to offer you a space that is not only beautiful but built to stand the test of time.",
                            style: color808080w40015,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("- Shukan Sky", style: colorFFFFFFw40020),
                          ),
                        ],
                      ),
                    ),
                    if (BuildingSiteController.to.buildingSiteData.value.specifications?.length == 0)
                      SizedBox()
                    else
                      Obx(() {
                        final specifications = BuildingSiteController.to.buildingSiteData.value.specifications ?? [];
                        const int initialCount = 3;

                        // decide how many items to show
                        final itemCount = BuildingSiteController.to.showAll.value
                            ? specifications.length
                            : (specifications.length > initialCount ? initialCount : specifications.length);

                        if (specifications.isEmpty) return const SizedBox();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  final spec = specifications[index];

                                  return Obx(() {
                                    final isVisible = FletController.to.isVisible(index);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => FletController.to.toggleVisibility(index),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(spec.header ?? "", style: color000000w40020),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: isVisible ? colorFF9800 : colorEEEEEE,
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                child: Icon(isVisible ? Icons.remove : Icons.add, color: color000000),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isVisible)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: List.generate(
                                                spec.descriptions?.length ?? 0,
                                                (descIndex) => Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${spec.descriptions?[descIndex].title ?? ""} - ", style: color000000w70015),
                                                      Expanded(
                                                        child: Text(
                                                          spec.descriptions?[descIndex].description ?? "",
                                                          softWrap: true,
                                                          style: color000000w40015,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        const Divider(),
                                      ],
                                    );
                                  });
                                },
                              ),
                              if (specifications.length > initialCount)
                                GestureDetector(
                                  onTap: () => BuildingSiteController.to.showAll.toggle(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: [
                                        Text(BuildingSiteController.to.showAll.value ? "View Less" : "View More", style: color000000w40020),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: colorEEEEEE),
                                          child: Image.asset(
                                            BuildingSiteController.to.showAll.value ? "assets/icon/up-arrow.png" : "assets/icon/arrow-down.png",
                                            scale: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Amenities That Enrich Everyday Living We believe a home is more than just walls—it’s an experience. Our thoughtfully curated amenities are designed to enhance your lifestyle with comfort, leisure, and convenience. Whether it’s unwinding in green open spaces, staying active in fitness zones,or enjoying moments with family at the clubhouse, every amenity adds value to your everyday life..",
                        style: color000000w40020,
                      ),
                    ),
                    SizedBox(height: 40),
                    BuildingSiteController.to.buildingSiteData.value.amenities?.length == 0
                        ? SizedBox()
                        : Obx(() {
                            final specifications = BuildingSiteController.to.buildingSiteData.value.amenities ?? [];
                            int initialCount = 6; // show 6 items before "View More"
                            int itemCount = BuildingSiteController.to.siteFeaturesAll.value
                                ? specifications.length
                                : (specifications.length > initialCount ? initialCount : specifications.length);

                            if (specifications.isEmpty) return SizedBox();

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: itemCount,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(imageUrl: BuildingSiteController.to.buildingSiteData.value.amenities?[index].icon ?? ""),
                                          AutoSizeText(
                                            BuildingSiteController.to.buildingSiteData.value.amenities?[index].name ?? "",
                                            style: color000000w40015,
                                            maxLines: 2,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  if (BuildingSiteController.to.buildingSiteData.value.amenities!.length > initialCount)
                                    GestureDetector(
                                      onTap: () => BuildingSiteController.to.siteFeaturesAll.toggle(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(BuildingSiteController.to.siteFeaturesAll.value ? "View Less" : "View More", style: color000000w40020),
                                          SizedBox(width: 15),
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: colorEEEEEE),
                                            child: Image.asset(
                                              BuildingSiteController.to.siteFeaturesAll.value
                                                  ? "assets/icon/up-arrow.png"
                                                  : "assets/icon/arrow-down.png",
                                              scale: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),

                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: color000000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              BuildingSiteController.to.buildingSiteData.value.about?.projectAddress ?? "",
                              textAlign: TextAlign.center,
                              style: colorFFFFFFw40015,
                            ),
                            SizedBox(height: 20),
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Explore', style: colorFFFFFFw60025),
                                  TextSpan(text: " the World", style: colorFFFFFFw40025),
                                  TextSpan(text: ' Through Our ', style: colorFFFFFFw60025),
                                  TextSpan(text: "360°, AR/VR", style: colorFFFFFFw40025),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CommonButton(
                                isLoading: false,
                                title: "Brochure",
                                onPressed: () {
                                  _openPDF(BuildingSiteController.to.buildingSiteData.value.about?.brochureUrl ?? "");
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250, // set any height you want
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: latLng ?? LatLng(0.000, 0.00), zoom: 14),
                        markers: _markers, //
                        zoomControlsEnabled: true,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      );
    });
  }
}

Future<void> _openPDF(String? brochureUrl) async {
  final Uri url = Uri.parse(brochureUrl ?? "");
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch';
  }
}
