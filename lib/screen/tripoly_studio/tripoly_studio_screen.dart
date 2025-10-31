import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/building_site_navigation_bar.dart';
import '../../common_widget/common_button_without_icon.dart';
import '../../controller/site_project_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class TripolyStudioScreen extends StatefulWidget {
  const TripolyStudioScreen({super.key});

  @override
  State<TripolyStudioScreen> createState() => _TripolyStudioScreenState();
}

class _TripolyStudioScreenState extends State<TripolyStudioScreen> {
  final SiteProjectController controllerX = Get.put(SiteProjectController());
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    await SiteProjectController.to.getSiteProjectApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        leading: SafeArea(
          child: Padding(padding: const EdgeInsets.only(left: 10, top: 30), child: Image.asset("assets/icon/logo_black.png", scale: 2)),
        ),
        leadingWidth: 170,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Obx(() {
              return SiteProjectController.to.siteProjectLoader == true
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height / 4,
                            viewportFraction: 1.2,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              controllerX.tripolyUpdateIndex(index);
                            },
                          ),
                          items: SiteProjectController.to.siteProjectData.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: item.path.toString(),
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.black)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          if (SiteProjectController.to.siteProjectData.isEmpty) {
                            return const SizedBox();
                          }
                          var currentItem = SiteProjectController.to.siteProjectData[controllerX.tripolyCurrentIndex.value];
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
                                      Text(currentItem.projectType.toString(), style: colorFF9800w40015),
                                      SizedBox(width: 15),
                                      Text("(360° - AR/VR)", style: color808080w40015),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(currentItem.projectDescription.toString(), style: color000000w40015),
                                  SizedBox(height: 45),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: controllerX.tripolyCurrentIndex.value > 0
                                            ? () {
                                                _carouselController.animateToPage(
                                                  controllerX.tripolyCurrentIndex.value - 1,
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
                                            color: controllerX.tripolyCurrentIndex.value <= 0 ? colorEEEEEE : color000000,
                                          ),
                                          child: Image.asset(
                                            "assets/icon/arrow.png",
                                            scale: 3,
                                            color: controllerX.tripolyCurrentIndex.value <= 0 ? color000000 : colorFF9800,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: CommonButtonWithoutIcon(
                                          isLoading: SiteProjectController.to.siteProjectLoader.value,
                                          title: "VIEW PROJECT",
                                          onPressed: () {
                                            Get.to(() => BuildingSiteNavigationBar(projectDetails: currentItem));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: controllerX.tripolyCurrentIndex.value < SiteProjectController.to.siteProjectData.length - 1
                                            ? () {
                                                _carouselController.animateToPage(
                                                  controllerX.tripolyCurrentIndex.value + 1,
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
                                            color: controllerX.tripolyCurrentIndex.value == SiteProjectController.to.siteProjectData.length - 1
                                                ? colorEEEEEE
                                                : color000000,
                                          ),
                                          child: Image.asset(
                                            "assets/icon/right-arrow.png",
                                            scale: 3,
                                            color: controllerX.tripolyCurrentIndex.value == SiteProjectController.to.siteProjectData.length - 1
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 15),
                        //       child: Text(
                        //         "${controllerX.tripolyCurrentIndex.value + 1} / ${SiteProjectController.to.siteProjectData.length}",
                        //         style: color000000w40020,
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 15),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             onTap: controllerX.tripolyCurrentIndex.value > 0
                        //                 ? () {
                        //                     _carouselController.animateToPage(
                        //                       controllerX.tripolyCurrentIndex.value - 1,
                        //                       duration: Duration(milliseconds: 300),
                        //                       curve: Curves.ease,
                        //                     );
                        //                   }
                        //                 : null,
                        //             child: Container(
                        //               height: 60,
                        //               width: 60,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(50),
                        //                 color: controllerX.tripolyCurrentIndex.value <= 0 ? colorEEEEEE : color000000,
                        //               ),
                        //               child: Image.asset(
                        //                 "assets/icon/arrow.png",
                        //                 scale: 3,
                        //                 color: controllerX.tripolyCurrentIndex.value <= 0 ? colorFFFFFF : colorFF9800,
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(width: 20),
                        //           GestureDetector(
                        //             onTap: controllerX.tripolyCurrentIndex.value < SiteProjectController.to.siteProjectData.length - 1
                        //                 ? () {
                        //                     _carouselController.animateToPage(
                        //                       controllerX.tripolyCurrentIndex.value + 1,
                        //                       duration: Duration(milliseconds: 300),
                        //                       curve: Curves.ease,
                        //                     );
                        //                   }
                        //                 : null,
                        //             child: Container(
                        //               height: 60,
                        //               width: 60,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(50),
                        //                 color: controllerX.tripolyCurrentIndex.value == SiteProjectController.to.siteProjectData.length - 1
                        //                     ? colorEEEEEE
                        //                     : color000000,
                        //               ),
                        //               child: Image.asset(
                        //                 "assets/icon/right-arrow.png",
                        //                 scale: 3,
                        //                 color: controllerX.tripolyCurrentIndex.value == SiteProjectController.to.siteProjectData.length - 1
                        //                     ? colorFFFFFF
                        //                     : colorFF9800,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }
}
