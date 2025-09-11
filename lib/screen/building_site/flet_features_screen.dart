import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripolystudionew/models/building_site_model.dart';

import '../../controller/building_site_controller.dart';
import '../../controller/flet_controller.dart';
import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class FletFeaturesScreen extends StatefulWidget {
  final List<Specification>? specificationDetails;
  final String? logoUrl;

  const FletFeaturesScreen({super.key, this.specificationDetails, this.logoUrl});

  @override
  State<FletFeaturesScreen> createState() => _FletFeaturesScreenState();
}

class _FletFeaturesScreenState extends State<FletFeaturesScreen> {
  final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());
  @override
  Widget build(BuildContext context) {
    final FletController fletController = Get.put(FletController());
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
        leadingWidth: 254,
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: BuildingSiteController.to.buildingSiteData.value.specifications?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FletController.to.toggleVisibility(index);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(BuildingSiteController.to.buildingSiteData.value.specifications?[index].header ?? "", style: color000000w40020),
                                Container(
                                  decoration: BoxDecoration(
                                    color: FletController.to.isVisible(index) ? colorFF9800 : colorEEEEEE,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                    child: Icon(FletController.to.isVisible(index) ? Icons.remove : Icons.add, color: color000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (FletController.to.isVisible(index))
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                BuildingSiteController.to.buildingSiteData.value.specifications?[index].descriptions?[0].description ?? "",
                                style: color000000w40015,
                              ),
                            ),
                          SizedBox(height: 20),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
