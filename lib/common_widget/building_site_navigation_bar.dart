import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tripolystudionew/controller/drawer_controller.dart';
import 'package:tripolystudionew/controller/nav_bar_controller.dart';
import 'package:tripolystudionew/controller/plan_controller.dart';

import '../controller/building_site_controller.dart';
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

class _BuildingSiteNavigationBarState extends State<BuildingSiteNavigationBar> {
  late final PersistentTabController _controller;
  late final NavController _navController;
  late final GalleryController _galleryController;
  late final PlanController _planController;
  late final BuildingSiteController _buildingSiteController;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    // Put controllers once — do not create them in build()
    _navController = Get.put(NavController());
    _galleryController = Get.put(GalleryController());
    _planController = Get.put(PlanController());
    _buildingSiteController = Get.put(BuildingSiteController());
  }

  @override
  void dispose() {
    // PersistentTabController doesn't require dispose, but if you had listeners detach them here.
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      SiteDetailScreen(projectDetails: widget.projectDetails),
      Container(), // placeholder for 3D view, kept as originally
      GalleryScreen(projectDetails: widget.projectDetails),
      BuildingPlanScreen(projectDetails: widget.projectDetails),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(BuildContext ctx) {
    return [
      // Home / Details
      PersistentBottomNavBarItem(
        onPressed: (context) {
          // immediate tab change is safe
          _controller.index = 0;
          NavController.to.selectedIndex.value = 0;
        },
        icon: Obx(
          () => Image.asset(
            "assets/icon/home.png",
            scale: 3,
            color: NavController.to.selectedIndex.value == 0 ? const Color(0xFFFF9800) : Colors.black,
          ),
        ),
      ),

      // 3D / Features (opens dialog)
      PersistentBottomNavBarItem(
        onPressed: (ctx) async {
          // Ensure tab selection is stable before opening dialog
          Future.microtask(() {
            _controller.index = 0;
            NavController.to.selectedIndex.value = 0;
          });

          // Build dialog using the provided context (ctx might be from nav package; use current ctx)
          final bool? selected = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: color000000,
              elevation: 8,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              title: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Features")),
              titleTextStyle: colorFFFFFFw40035,
              content: Obx(() {
                final names = BottomNavigationController.to.activityName;
                final screens = BottomNavigationController.to.navigationScreen;
                return SizedBox(
                  height: 210,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isSelected = BottomNavigationController.to.selectedIndex.value == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              onTap: () {
                                // Close dialog then navigate — close first to avoid doing navigation while dialog is building
                                Navigator.of(dialogContext).pop(true);
                                BottomNavigationController.to.selectItem(index);
                                // schedule navigation next frame to avoid build-time conflicts
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  final Widget? target = BottomNavigationController.to.navigationScreen.length > index
                                      ? BottomNavigationController.to.navigationScreen[index] as Widget
                                      : null;
                                  if (target != null) {
                                    Get.to(() => target);
                                  }
                                });
                              },
                              title: Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(color: isSelected ? colorFF9800 : colorFFFFFF, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 25),
                                  Text(names[index], style: isSelected ? colorFF9800w40030 : colorFFFFFFw40030),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                );
              }),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Back", style: colorFF9800w40015),
                ),
              ],
            ),
          );

          // If user explicitly selected (we used pop(true) on item tap), update nav
          if (selected == true) {
            NavController.to.selectedIndex.value = 1;
            _controller.index = 1;
          }
          // no automatic Get.back(); — dialog already closed via Navigator.pop(...)
        },
        icon: Obx(
          () => Image.asset(
            "assets/icon/3d-view.png",
            scale: 3,
            color: NavController.to.selectedIndex.value == 1 ? const Color(0xFFFF9800) : Colors.black,
          ),
        ),
      ),

      // Gallery
      PersistentBottomNavBarItem(
        onPressed: (context) async {
          try {
            NavController.to.selectedIndex.value = 2;
            // load gallery, await result before switching tab so user sees content loading if needed
            await GalleryController.to.getGalleryApiCall(widget.projectDetails?.projectId);
            _controller.index = 2;
          } catch (e) {
            // handle errors or show snackbar
            if (mounted) {
              //ScaffoldMessenger.of(BuildContext context).showSnackBar(SnackBar(content: Text('Failed to load gallery')));
            }
          }
        },
        icon: Obx(
          () => Image.asset(
            "assets/icon/gallery.png",
            scale: 3,
            color: NavController.to.selectedIndex.value == 2 ? const Color(0xFFFF9800) : Colors.black,
          ),
        ),
      ),

      // Plans
      PersistentBottomNavBarItem(
        onPressed: (context) async {
          try {
            NavController.to.selectedIndex.value = 3;
            await PlanController.to.getPlanApiCall(widget.projectDetails?.projectId);
            _controller.index = 3;
          } catch (e) {
            if (mounted) {
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load plans')));
            }
          }
        },
        icon: Obx(
          () => Image.asset(
            "assets/icon/plan.png",
            scale: 3,
            color: NavController.to.selectedIndex.value == 3 ? const Color(0xFFFF9800) : Colors.black,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    return Scaffold(
      backgroundColor: colorEEEEEE,
      body: PersistentTabView(
        context,
        screens: screens,
        controller: _controller,
        items: _navBarItems(context),
        navBarHeight: 65,
        navBarStyle: NavBarStyle.style6,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        backgroundColor: colorF2F2F2,
        onItemSelected: (index) {
          // keep NavController in sync
          NavController.to.changeTab(index);
        },
        decoration: NavBarDecoration(
          colorBehindNavBar: colorFFFFFF,
          border: Border(top: BorderSide(color: colorFF9800)),
          boxShadow: [BoxShadow(color: colorF8D691, blurRadius: 10, offset: Offset(0, -1))],
        ),
      ),
    );
  }
}
