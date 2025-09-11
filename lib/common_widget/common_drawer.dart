// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tripolystudionew/controller/drawer_controller.dart';
// import 'package:tripolystudionew/models/site_project_model.dart';
//
// import '../utility/colors.dart';
// import '../utility/text_style.dart';
// // ?.......Drawer Widget for dashboard........
//
// Widget commonDrawer(BuildContext context, {SiteProjectModel? projectDetail}) {
//   // final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());
//   // List<String> activityName = ["Interior", "Exterior", "Amenities"];
//   // final SiteProjectController siteProjectController = SiteProjectController();
//   // final InteriorController interiorController = Get.put(InteriorController());
//   // List navigationScreen = [
//   //   InteriorDetailScreen(projectDetail: projectDetail),
//   //   ExteriorDetailScreen(projectDetail: projectDetail),
//   //   SiteAmenitiesScreen(projectDetail: projectDetail),
//   // ];
//   return Drawer(
//     backgroundColor: colorEEEEEE,
//     child: Column(
//       children: [
//         SafeArea(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 30, top: 20),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Icon(Icons.close, size: 35),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Obx(() {
//               return ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: BottomNavigationController.to.activityName.length,
//                 itemBuilder: (context, index) {
//                   return Obx(
//                     () => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             title: GestureDetector(
//                               onTap: () {
//                                 print(index);
//                                 BottomNavigationController.to.selectItem(index);
//                                 Get.to(() => BottomNavigationController.to.navigationScreen[index] as Widget);
//                               },
//                               child: Row(
//                                 children: [
//                                   BottomNavigationController.to.selectedIndex.value == index
//                                       ? Container(
//                                           width: 20,
//                                           height: 20,
//                                           decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
//                                         )
//                                       : SizedBox(),
//                                   SizedBox(width: 10),
//                                   Text(
//                                     BottomNavigationController.to.activityName[index],
//                                     style: BottomNavigationController.to.selectedIndex.value == index ? colorFF9800w40025 : color000000w40023,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // onTap: () {
//                             //   print(index);
//                             //   BottomNavigationController.to.selectItem(index);
//                             //   Navigator.pop(context); // Close drawer
//                             // },
//                           ),
//                           Divider(color: color808080),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ),
//       ],
//     ),
//   );
// }
