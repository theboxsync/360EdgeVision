import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tripolystudionew/controller/amenities_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';

import '../../common_widget/common_app_bar.dart';
import '../../common_widget/common_button.dart';
import '../../controller/building_site_controller.dart';
import '../../controller/nav_bar_controller.dart';
import '../../controller/site_project_controller.dart';
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
  final SiteProjectController controllerX = Get.put(SiteProjectController());
  final AmenitiesController amenitiesController = Get.put(AmenitiesController());
  final CarouselSliderController _carouselController = CarouselSliderController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    await AmenitiesController.to.getProjectAmenitiesApiCall(widget.projectDetail?.projectId);
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller = PersistentTabController(initialIndex: 0);
    return Obx(() {
      return Scaffold(
        appBar: commonAppBar(
          logoUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? "",
          isBack: true,
          onBackPressed: () {
            Get.back();
            Get.back();
            NavController.to.selectedIndex.value = 0;
            controller.index = 0;
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Obx(() {
                return AmenitiesController.to.projectAmenitiesLoader == true
                    ? const Center(child: CircularProgressIndicator(color: Colors.black))
                    : Column(
                        children: [
                          CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 4,
                              viewportFraction: 1.2,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                controllerX.amenitiesUpdateIndex(index);
                              },
                            ),
                            items: AmenitiesController.to.projectAmenitiesData.value.collections?.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    width: MediaQuery.of(context).size.width,
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
                          Obx(() {
                            final collections = AmenitiesController.to.projectAmenitiesData.value.collections ?? [];

                            if (collections.isEmpty) {
                              return const SizedBox(height: 200, child: Center(child: Text("No amenities data found")));
                            }

                            final safeIndex = controllerX.amenitiesCurrentIndex.value.clamp(0, collections.length - 1);
                            final currentItem = collections[safeIndex];

                            return Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(color: colorF2F2F2),
                              child: Padding(
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
                                        Text("Amenities", style: color808080w40015),
                                      ],
                                    ),
                                    const SizedBox(height: 45),
                                    CommonButton(
                                      isLoading: false,
                                      title: "View Project",
                                      onPressed: () {
                                        Get.to(() => PanoramaScreen(collection: currentItem));
                                      },
                                    ),
                                    const SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "${controllerX.amenitiesCurrentIndex.value + 1} / ${AmenitiesController.to.projectAmenitiesData.value.collections?.length ?? 0}",
                                  style: color000000w40020,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: controllerX.amenitiesCurrentIndex.value > 0
                                          ? () {
                                              _carouselController.animateToPage(
                                                controllerX.amenitiesCurrentIndex.value - 1,
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            }
                                          : null,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: controllerX.amenitiesCurrentIndex.value <= 0 ? colorEEEEEE : color000000,
                                        ),
                                        child: Image.asset(
                                          "assets/icon/arrow.png",
                                          scale: 3,
                                          color: controllerX.amenitiesCurrentIndex.value <= 0 ? colorFFFFFF : colorFF9800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap:
                                          controllerX.amenitiesCurrentIndex.value <
                                              (AmenitiesController.to.projectAmenitiesData.value.collections?.length ?? 0) - 1
                                          ? () {
                                              _carouselController.animateToPage(
                                                controllerX.amenitiesCurrentIndex.value + 1,
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            }
                                          : null,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color:
                                              controllerX.amenitiesCurrentIndex.value ==
                                                  (AmenitiesController.to.projectAmenitiesData.value.collections?.length ?? 0) - 1
                                              ? colorEEEEEE
                                              : color000000,
                                        ),
                                        child: Image.asset(
                                          "assets/icon/right-arrow.png",
                                          scale: 3,
                                          color:
                                              controllerX.amenitiesCurrentIndex.value ==
                                                  (AmenitiesController.to.projectAmenitiesData.value.collections?.length ?? 0) - 1
                                              ? colorFFFFFF
                                              : colorFF9800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
              }),
            ),
          ),
        ),
      );
    });
  }
}
