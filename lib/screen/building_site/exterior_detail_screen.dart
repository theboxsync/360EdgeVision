import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/common_widget/building_site_navigation_bar.dart';
import 'package:tripolystudionew/common_widget/common_button_without_icon.dart';
import 'package:tripolystudionew/controller/building_site_controller.dart';
import 'package:tripolystudionew/controller/exterior_controller.dart';
import 'package:tripolystudionew/controller/site_project_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';
import 'package:tripolystudionew/utility/colors.dart';
import 'package:tripolystudionew/utility/text_style.dart';

import '../../common_widget/common_app_bar.dart';
import '360_view_screen.dart';

class ExteriorDetailScreen extends StatefulWidget {
  final SiteProjectModel? projectDetail;
  const ExteriorDetailScreen({super.key, this.projectDetail});

  @override
  State<ExteriorDetailScreen> createState() => _ExteriorDetailScreenState();
}

class _ExteriorDetailScreenState extends State<ExteriorDetailScreen> {
  final ExteriorController _exteriorController = Get.put(ExteriorController());
  final SiteProjectController _projectController = Get.put(SiteProjectController());
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    await ExteriorController.to.getProjectExteriorApiCall(widget.projectDetail?.projectId);
  }

  /// ✅ Proper back navigation — scheduled safely
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
          final collections = ExteriorController.to.projectExteriorData.value.collections ?? [];

          if (collections.isEmpty) {
            return const Center(child: Text("No exterior data found"));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  /// --- Carousel Section ---
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 4,
                      viewportFraction: 1.2,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        _projectController.exteriorUpdateIndex(index);
                      },
                    ),
                    items: collections.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              width: double.infinity,
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

                  /// --- Project Info ---
                  Obx(() {
                    final safeIndex = _projectController.exteriorCurrentIndex.value.clamp(0, collections.length - 1);
                    final currentItem = collections[safeIndex];

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: colorF2F2F2, borderRadius: BorderRadius.circular(8)),
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
                              Text("Exterior", style: color808080w40015),
                            ],
                          ),
                          const SizedBox(height: 45),

                          /// --- Navigation Buttons ---
                          Row(
                            children: [
                              /// Left Arrow
                              GestureDetector(
                                onTap: _projectController.exteriorCurrentIndex.value > 0
                                    ? () {
                                        _carouselController.animateToPage(
                                          _projectController.exteriorCurrentIndex.value - 1,
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
                                    color: _projectController.exteriorCurrentIndex.value <= 0 ? colorEEEEEE : color000000,
                                  ),
                                  child: Image.asset(
                                    "assets/icon/arrow.png",
                                    scale: 3,
                                    color: _projectController.exteriorCurrentIndex.value <= 0 ? color000000 : colorFF9800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              /// View Project Button
                              Expanded(
                                child: CommonButtonWithoutIcon(
                                  isLoading: false,
                                  title: "View Project",
                                  onPressed: () {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      Get.to(() => PanoramaScreen(collection: currentItem));
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),

                              /// Right Arrow
                              GestureDetector(
                                onTap: _projectController.exteriorCurrentIndex.value < (collections.length - 1)
                                    ? () {
                                        _carouselController.animateToPage(
                                          _projectController.exteriorCurrentIndex.value + 1,
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
                                    color: _projectController.exteriorCurrentIndex.value == (collections.length - 1) ? colorEEEEEE : color000000,
                                  ),
                                  child: Image.asset(
                                    "assets/icon/right-arrow.png",
                                    scale: 3,
                                    color: _projectController.exteriorCurrentIndex.value == (collections.length - 1) ? color000000 : colorFF9800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
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
