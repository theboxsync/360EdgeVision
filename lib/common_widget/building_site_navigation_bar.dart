import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tripolystudionew/controller/nav_bar_controller.dart';
import 'package:tripolystudionew/controller/plan_controller.dart';

import '../controller/building_site_controller.dart';
import '../controller/drawer_controller.dart';
import '../controller/gallery_controller.dart';
import '../models/site_project_model.dart';
import '../screen/building_site/building_plan_screen.dart';
import '../screen/building_site/gallery_screen.dart';
import '../screen/building_site/site_detail_screen.dart';
import '../utility/colors.dart';
import '../utility/text_style.dart';

class BuildingSiteNavigationBar extends StatefulWidget {
  final SiteProjectModel? projectDetails;
  const BuildingSiteNavigationBar({super.key, this.projectDetails});

  @override
  State<BuildingSiteNavigationBar> createState() => _BuildingSiteNavigationBarState();
}

final GlobalKey<ScaffoldState> keyDrawer = GlobalKey();

class _BuildingSiteNavigationBarState extends State<BuildingSiteNavigationBar> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller = PersistentTabController(initialIndex: 0);
    final NavController navController = Get.put(NavController());
    final GalleryController galleryController = Get.put(GalleryController());
    final PlanController planController = Get.put(PlanController());
    final BuildingSiteController buildingSiteController = Get.put(BuildingSiteController());

    List<Widget> screens = [
      SiteDetailScreen(projectDetails: widget.projectDetails),
      Container(),
      GalleryScreen(projectDetails: widget.projectDetails),
      BuildingPlanScreen(projectDetails: widget.projectDetails),
    ];

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          onPressed: (context) async {
            controller.index = 0;
            NavController.to.selectedIndex.value = 0;
            // await BuildingSiteController.to.getBuildingSiteApiCall(widget.projectDetails?.projectId);
          },
          icon: Obx(
            () => Image.asset(
              "assets/icon/home.png",
              scale: NavController.to.selectedIndex.value == 0 ? 4 : 5,
              color: NavController.to.selectedIndex.value == 0 ? Color(0xFFFF9800) : Colors.black,
            ),
          ),

          //activeColorPrimary: Color(0xFFFF9800),
          //inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          onPressed: (ctx) async {
            Future.microtask(() {
              controller.index = 0;
              NavController.to.selectedIndex.value = 0;
            });
            bool? confirm = await showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: color000000,
                elevation: 8,
                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                title: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Features")),
                titleTextStyle: colorFFFFFFw40035,
                content: Obx(() {
                  return SizedBox(
                    height: 210,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: BottomNavigationController.to.activityName.length,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: ListTile(
                                      onTap: () {
                                        BottomNavigationController.to.selectItem(index);
                                        Get.to(() => BottomNavigationController.to.navigationScreen[index] as Widget);
                                      },
                                      title: Row(
                                        children: [
                                          BottomNavigationController.to.selectedIndex.value == index
                                              ? Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(color: colorFF9800, shape: BoxShape.circle),
                                                )
                                              : Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(color: colorFFFFFF, shape: BoxShape.circle),
                                                ),
                                          SizedBox(width: 25),
                                          Text(
                                            BottomNavigationController.to.activityName[index],
                                            style: BottomNavigationController.to.selectedIndex.value == index ? colorFF9800w40030 : colorFFFFFFw40030,
                                          ),
                                        ],
                                      ),
                                      // onTap: () {
                                      //   print(index);
                                      //   BottomNavigationController.to.selectItem(index);
                                      //   Navigator.pop(context); // Close drawer
                                      // },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Back", style: colorFF9800w40015),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              NavController.to.selectedIndex.value = 1;
              controller.index = 1;
            }
          },
          icon: Obx(
            () => Image.asset(
              "assets/icon/building.png",
              scale: NavController.to.selectedIndex.value == 1 ? 4 : 5,
              color: NavController.to.selectedIndex.value == 1 ? Color(0xFFFF9800) : Colors.black,
            ),
          ),

          //activeColorPrimary: Color(0xFFFF9800),
          //inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Obx(
            () => Image.asset(
              "assets/icon/gallery.png",
              scale: NavController.to.selectedIndex.value == 2 ? 5 : 6,
              color: NavController.to.selectedIndex.value == 2 ? Color(0xFFFF9800) : Colors.black,
            ),
          ),
          onPressed: (context) async {
            NavController.to.selectedIndex.value = 2;
            await GalleryController.to.getGalleryApiCall(widget.projectDetails?.projectId);
            controller.index = 2;
            // print(widget.projectDetails?.projectId);
          },
          //activeColorPrimary: Color(0xFFFF9800),
          // inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: Obx(
            () => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                "assets/icon/plan.png",
                scale: NavController.to.selectedIndex.value == 3 ? 4 : 5,
                color: NavController.to.selectedIndex.value == 3 ? Color(0xFFFF9800) : Colors.black,
              ),
            ),
          ),
          onPressed: (context) async {
            NavController.to.selectedIndex.value = 3;
            await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId);
            controller.index = 3;
            // print(widget.projectDetails?.projectId);
          },
          //activeColorPrimary: Color(0xFFFF9800),
          // inactiveColorPrimary: Colors.black,
        ),
      ];
    }

    return Scaffold(
      backgroundColor: colorEEEEEE,
      // key: keyDrawer,
      // endDrawer: commonDrawer(context, projectDetail: widget.projectDetails),
      body: PersistentTabView(
        context,
        screens: screens,
        controller: controller,
        items: navBarsItems(),
        navBarHeight: 65,
        navBarStyle: NavBarStyle.style6,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        backgroundColor: colorF2F2F2,
        onItemSelected: (index) {
          NavController.to.changeTab(index);
        },
        decoration: NavBarDecoration(
          colorBehindNavBar: colorFFFFFF,
          border: Border(top: BorderSide(color: colorFF9800)),
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [BoxShadow(color: colorF8D691, blurRadius: 10, offset: Offset(0, -1))],
        ),
      ),
    );
  }
}
