// To parse this JSON data, do
//
//     final hotspotImageModel = hotspotImageModelFromJson(jsonString);

import 'dart:convert';

HotspotImageModel hotspotImageModelFromJson(String str) => HotspotImageModel.fromJson(json.decode(str));

String hotspotImageModelToJson(HotspotImageModel data) => json.encode(data.toJson());

class HotspotImageModel {
  String? imagePath;
  String? collectionId;

  HotspotImageModel({this.imagePath, this.collectionId});

  factory HotspotImageModel.fromJson(Map<String, dynamic> json) =>
      HotspotImageModel(imagePath: json["imagePath"], collectionId: json["collection_id"]);

  Map<String, dynamic> toJson() => {"imagePath": imagePath, "collection_id": collectionId};
}
