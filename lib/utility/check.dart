import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramaWithHotspots extends StatelessWidget {
  final List<Map<String, dynamic>> hotspotList;

  const PanoramaWithHotspots({required this.hotspotList, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PanoramaViewer(
        animSpeed: 1.0,
        animReverse: true, // Continue rotating in the same direction
        interactive: true,
        child: Image.asset("assets/images/Terrace_CAm 01.webp"),
        hotspots: hotspotList.map((data) {
          return Hotspot(
            latitude: data["pitch"], // pitch → latitude
            longitude: data["yaw"], // yaw → longitude
            width: 60,
            height: 60,
            widget: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(child: Image.network("https://your-server.com/detail/${data["linked_image_id"]}", fit: BoxFit.cover)),
                );
              },
              child: Icon(Icons.location_on, size: 40, color: Colors.red),
            ),
          );
        }).toList(),
      ),
    );
  }
}
