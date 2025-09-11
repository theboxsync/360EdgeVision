import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/models/building_site_model.dart';

import '../../controller/building_site_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class SiteFeaturesScreen extends StatefulWidget {
  final List<Amenities>? amenitiesDetails;
  final String? logoUrl;
  const SiteFeaturesScreen({super.key, this.amenitiesDetails, this.logoUrl});

  @override
  State<SiteFeaturesScreen> createState() => _SiteFeaturesScreenState();
}

class _SiteFeaturesScreenState extends State<SiteFeaturesScreen> {
  final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black), // or any color
                onPressed: () => Get.back(),
              ),
              CachedNetworkImage(
                scale: 1,
                imageUrl: widget.logoUrl ?? "https://360edgevision.digitaltripolystudio.com/admin/my-media/upload/1/6863d939b04e2_logo.png",
              ),
            ],
          ),
        ),
        leadingWidth: 220,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                itemCount: 15,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(imageUrl: BuildingSiteController.to.buildingSiteData.value.amenities?[index].icon ?? ""),
                          AutoSizeText(
                            BuildingSiteController.to.buildingSiteData.value.amenities?[index].name ?? "",
                            style: color000000w40010,
                            maxLines: 2,
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
