import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/common_widget/building_site_navigation_bar.dart';
import 'package:tripolystudionew/common_widget/common_button_without_icon.dart';
import 'package:tripolystudionew/controller/amenities_controller.dart';
import 'package:tripolystudionew/controller/site_project_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';

import '../../common_widget/common_app_bar.dart';
import '../../controller/building_site_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';
import '360_view_screen.dart';

class SiteAmenitiesScreen extends StatefulWidget {
  final SiteProjectModel? projectDetail;
  const SiteAmenitiesScreen({super.key, this.projectDetail});

  @override
  State<SiteAmenitiesScreen> createState() => _SiteAmenitiesScreenState();
}

class _SiteAmenitiesScreenState extends State<SiteAmenitiesScreen> {
  final SiteProjectController siteProjectController = Get.put(SiteProjectController());
  final AmenitiesController amenitiesController = Get.put(AmenitiesController());
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    final id = widget.projectDetail?.projectId;
    if (id != null) {
      await AmenitiesController.to.getProjectAmenitiesApiCall(id);
    }
  }

  Future<bool> _onWillPop() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAll(() => BuildingSiteNavigationBar(projectDetails: widget.projectDetail));
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: commonAppBar(
          logoUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? "",
          isBack: true,
          onBackPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => BuildingSiteNavigationBar(projectDetails: widget.projectDetail));
            });
          },
        ),
        body: Obx(() {
          if (AmenitiesController.to.projectAmenitiesLoader == true) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final collections = AmenitiesController.to.projectAmenitiesData.value.collections ?? [];
          if (collections.isEmpty) {
            return const Center(child: Text("No amenities data found"));
          }

          final safeIndex = siteProjectController.amenitiesCurrentIndex.value.clamp(0, collections.length - 1);
          final currentItem = collections[safeIndex];

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 4,
                      viewportFraction: 1.2,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        siteProjectController.amenitiesUpdateIndex(index);
                      },
                    ),
                    items: collections.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: item.image?.imagePath ?? "",
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.black)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: colorF2F2F2),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentItem.projectName ?? "", style: color000000w60025),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(currentItem.collectionName ?? "", style: colorFF9800w40015),
                            const SizedBox(width: 15),
                            const Text("Amenities", style: color808080w40015),
                          ],
                        ),
                        const SizedBox(height: 45),

                        Row(
                          children: [
                            // Left Arrow
                            GestureDetector(
                              onTap: safeIndex > 0
                                  ? () {
                                      _carouselController.animateToPage(
                                        safeIndex - 1,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    }
                                  : null,
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: color000000),
                                  borderRadius: BorderRadius.circular(50),
                                  color: safeIndex <= 0 ? colorEEEEEE : color000000,
                                ),
                                child: Image.asset("assets/icon/arrow.png", scale: 3, color: safeIndex <= 0 ? color000000 : colorFF9800),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // View Project Button
                            Expanded(
                              child: CommonButtonWithoutIcon(
                                isLoading: false,
                                title: "View Project",
                                onPressed: () {
                                  Get.to(() => PanoramaScreen(collection: currentItem));
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Right Arrow
                            GestureDetector(
                              onTap: safeIndex < collections.length - 1
                                  ? () {
                                      _carouselController.animateToPage(
                                        safeIndex + 1,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    }
                                  : null,
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: color000000),
                                  borderRadius: BorderRadius.circular(50),
                                  color: safeIndex == collections.length - 1 ? colorEEEEEE : color000000,
                                ),
                                child: Image.asset(
                                  "assets/icon/right-arrow.png",
                                  scale: 3,
                                  color: safeIndex == collections.length - 1 ? color000000 : colorFF9800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
