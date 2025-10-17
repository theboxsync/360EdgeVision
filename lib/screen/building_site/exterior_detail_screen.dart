import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tripolystudionew/common_widget/common_button_without_icon.dart';
import 'package:tripolystudionew/controller/exterior_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';

import '../../common_widget/common_app_bar.dart';
import '../../controller/building_site_controller.dart';
import '../../controller/site_project_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';
import '360_view_screen.dart';

class ExteriorDetailScreen extends StatefulWidget {
  final SiteProjectModel? projectDetail;
  const ExteriorDetailScreen({super.key, this.projectDetail});

  @override
  State<ExteriorDetailScreen> createState() => _ExteriorDetailScreenState();
}

class _ExteriorDetailScreenState extends State<ExteriorDetailScreen> {
  final ExteriorController interiorController = Get.put(ExteriorController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    await ExteriorController.to.getProjectExteriorApiCall(widget.projectDetail?.projectId);
  }

  Future<bool> _onWillPop() async {
    Get.back();
    Get.back();
    return false; // prevent auto pop after manual navigation
  }

  @override
  Widget build(BuildContext context) {
    final SiteProjectController controllerX = Get.put(SiteProjectController());
    final CarouselSliderController _carouselController = CarouselSliderController();
    PersistentTabController controller = PersistentTabController(initialIndex: 0);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() {
        return Scaffold(
          appBar: commonAppBar(
            logoUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? "",
            isBack: true,
            onBackPressed: () {
              Get.back();
              Get.back();
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
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
                          controllerX.exteriorUpdateIndex(index);
                        },
                      ),
                      items: ExteriorController.to.projectExteriorData.value.collections?.map((item) {
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
                      final collections = ExteriorController.to.projectExteriorData.value.collections ?? [];

                      if (collections.isEmpty) {
                        return const SizedBox(height: 200, child: Center(child: Text("No exterior data found")));
                      }

                      final safeIndex = controllerX.exteriorCurrentIndex.value.clamp(0, collections.length - 1);
                      final currentItem = collections[safeIndex];

                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: colorF2F2F2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentItem.projectName ?? "", style: color000000w60025),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(currentItem.collectionName ?? "", style: colorFF9800w40015),
                                  SizedBox(width: 15),
                                  Text("Exterior", style: color808080w40015),
                                ],
                              ),
                              SizedBox(height: 45),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: controllerX.exteriorCurrentIndex.value > 0
                                        ? () {
                                            _carouselController.animateToPage(
                                              controllerX.exteriorCurrentIndex.value - 1,
                                              duration: Duration(milliseconds: 300),
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
                                        color: controllerX.exteriorCurrentIndex.value <= 0 ? colorEEEEEE : color000000,
                                      ),
                                      child: Image.asset(
                                        "assets/icon/arrow.png",
                                        scale: 3,
                                        color: controllerX.exteriorCurrentIndex.value <= 0 ? color000000 : colorFF9800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                  GestureDetector(
                                    onTap:
                                        controllerX.exteriorCurrentIndex.value <
                                            (ExteriorController.to.projectExteriorData.value.collections?.length ?? 0) - 1
                                        ? () {
                                            _carouselController.animateToPage(
                                              controllerX.exteriorCurrentIndex.value + 1,
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                          }
                                        : null,
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: color000000),
                                        color:
                                            controllerX.exteriorCurrentIndex.value ==
                                                (ExteriorController.to.projectExteriorData.value.collections?.length ?? 0) - 1
                                            ? colorEEEEEE
                                            : color000000,
                                      ),
                                      child: Image.asset(
                                        "assets/icon/right-arrow.png",
                                        scale: 3,
                                        color:
                                            controllerX.exteriorCurrentIndex.value ==
                                                (ExteriorController.to.projectExteriorData.value.collections?.length ?? 0) - 1
                                            ? color000000
                                            : colorFF9800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
