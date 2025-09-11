import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tripolystudionew/controller/gallery_controller.dart';
import 'package:tripolystudionew/models/site_project_model.dart';

import '../../common_widget/common_app_bar.dart';
import '../../controller/building_site_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class GalleryScreen extends StatefulWidget {
  final SiteProjectModel? projectDetails;
  const GalleryScreen({super.key, this.projectDetails});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final List<String> imageUrls;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    imageUrls = (GalleryController.to.galleryData.value.data?.map((e) => e.path.toString()).toList()) ?? [];
    print(imageUrls);
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
                    Text("Gallery", style: color000000w60025),
                    const SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: const Text("All", style: color000000w40015),
                        value: GalleryController.to.selectedCategory.value,
                        isExpanded: false,
                        items: GalleryController.to.categories
                            ?.toSet()
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category, style: color000000w40015),
                              ),
                            )
                            .toList(),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color000000),
                            color: Colors.white,
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color000000, // Border color
                              width: 1, // Border width
                            ),
                            color: Colors.white, // Background color
                          ),
                        ),
                        onChanged: (value) async {
                          // setState(() {
                          //   selectedCategory = value as String?; // updates UI
                          // });
                          GalleryController.to.selectedCategory.value = value as String?;
                          print(value);
                          if (GalleryController.to.selectedCategory.value == "All") {
                            await GalleryController.to.getGalleryApiCall(widget.projectDetails?.projectId);
                          } else if (GalleryController.to.selectedCategory.value == "Exterior") {
                            await GalleryController.to.getGalleryApiCall(widget.projectDetails?.projectId, "1");
                          } else if (GalleryController.to.selectedCategory.value == "Interior") {
                            await GalleryController.to.getGalleryApiCall(widget.projectDetails?.projectId, "2");
                          }
                        },
                        // buttonStyleData: const ButtonStyleData(height: 48, padding: EdgeInsets.symmetric(horizontal: 12)),
                        //dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Expanded GridView
                Expanded(
                  child: GridView.builder(
                    itemCount: GalleryController.to.galleryData.value.data?.length,
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
                              imageUrl: GalleryController.to.galleryData.value.data![index].path.toString(),
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
