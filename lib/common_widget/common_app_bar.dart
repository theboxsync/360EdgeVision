import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tripolystudionew/utility/colors.dart';

commonAppBar({
  bool isCenterTitle = true,
  bool isLeading = false,
  bool isBack = false,
  Color? backgroundColor,
  Color? menuIconColor,
  final VoidCallback? onSuffixPressed,
  final VoidCallback? onBackPressed,
  // String logoUrl = "",
  Widget? suffixWidget,
  required String logoUrl,
  bool isSuffixWidget = false,
  // bool isDrawerWidget = false,
  bool isWidget = false,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? colorFFFFFF,
    leading: Padding(
      padding: const EdgeInsets.only(left: 5, top: 5),
      child: Row(
        children: [
          isBack
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black), // or any color
                  onPressed: onBackPressed,
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: (logoUrl.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: logoUrl,
                    // placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.black)),
                    // errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : const Icon(Icons.image_not_supported),
          ),
        ],
      ),
    ),
    // actions: [
    //   isDrawerWidget
    //       ? Padding(
    //           padding: const EdgeInsets.only(right: 10),
    //           child: GestureDetector(
    //             onTap: () {
    //               keyDrawer.currentState!.openEndDrawer();
    //             },
    //             child: Icon(Icons.menu, color: menuIconColor ?? color000000),
    //           ),
    //         )
    //       : SizedBox(),
    // ],
    leadingWidth: 300,
  );
}
