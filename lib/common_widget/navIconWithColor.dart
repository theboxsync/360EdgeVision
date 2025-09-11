import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../utility/colors.dart';

class NavIconWithColor extends StatelessWidget {
  final String assetPath;
  final int tabIndex;
  final PersistentTabController controller;

  const NavIconWithColor({super.key, required this.assetPath, required this.tabIndex, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isActive = controller.index == tabIndex;
    print(isActive);
    return Image.asset(assetPath, scale: 5, color: isActive ? Color(0xFFFF9800) : color000000);
  }
}
