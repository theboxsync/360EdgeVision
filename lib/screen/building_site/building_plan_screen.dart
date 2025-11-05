import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tripolystudionew/controller/plan_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';

import '../../common_widget/common_app_bar.dart';
import '../../controller/building_site_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class BuildingPlanScreen extends StatefulWidget {
  final SiteProjectModel? projectDetails;
  const BuildingPlanScreen({super.key, this.projectDetails});
  @override
  State<BuildingPlanScreen> createState() => _BuildingPlanScreenState();
}

class _BuildingPlanScreenState extends State<BuildingPlanScreen> {
  late final List<String> imageUrls;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // _getData();
    imageUrls = (PlanController.to.planData.value.plan?.map((e) => e.imagePath.toString()).toList()) ?? [];
    print(imageUrls);
  }

  _getData() async {
    await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(logoUrl: BuildingSiteController.to.buildingSiteData.value.about?.logoOriginalUrl ?? ""),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Plans", style: color000000w60025),
                    const SizedBox(width: 10),
                    // DropdownButton2(
                    //   hint: const Text("All", style: color000000w40015),
                    //   value: GalleryController.to.selectedCategory.value,
                    //   isExpanded: false,
                    //   items: GalleryController.to.categories
                    //       ?.toSet()
                    //       .map(
                    //         (category) => DropdownMenuItem(
                    //           value: category,
                    //           child: Text(category, style: color000000w40015),
                    //         ),
                    //       )
                    //       .toList(),
                    //   dropdownStyleData: DropdownStyleData(
                    //     maxHeight: 200,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(color: color000000),
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   buttonStyleData: ButtonStyleData(
                    //     height: 48,
                    //     padding: const EdgeInsets.symmetric(horizontal: 12),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(
                    //         color: color000000, // Border color
                    //         width: 1, // Border width
                    //       ),
                    //       color: Colors.white, // Background color
                    //     ),
                    //   ),
                    //   onChanged: (value) async {
                    //     PlanController.to.selectedCategory.value = value as String?;
                    //     print(value);
                    //     if (PlanController.to.selectedCategory.value == "All") {
                    //       await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId);
                    //     } else if (PlanController.to.selectedCategory.value == "Exterior") {
                    //       await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId, "1");
                    //     } else if (PlanController.to.selectedCategory.value == "Interior") {
                    //       await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId, "2");
                    //     }
                    //   },
                    //   // buttonStyleData: const ButtonStyleData(height: 48, padding: EdgeInsets.symmetric(horizontal: 12)),
                    //   //dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                    // ),
                  ],
                ),

                const SizedBox(height: 20),

                // Expanded GridView
                Expanded(
                  child: GridView.builder(
                    itemCount: PlanController.to.planData.value.plan?.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showImageViewer(context, imageUrls, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: color000000, borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: PlanController.to.planData.value.plan![index].imagePath.toString(),
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: color000000)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImageViewer(BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      useSafeArea: false,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            color: color000000,
            child: PhotoViewGallery.builder(
              pageController: PageController(initialPage: initialIndex),
              itemCount: images.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator(color: colorFFFFFF)),
            ),
          ),
        );
      },
    );
  }
}
