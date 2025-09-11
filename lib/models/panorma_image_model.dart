// To parse this JSON data, do
//
//     final panoramaImageModel = panoramaImageModelFromJson(jsonString);

import 'dart:convert';

PanoramaImageModel panoramaImageModelFromJson(String str) => PanoramaImageModel.fromJson(json.decode(str));

String panoramaImageModelToJson(PanoramaImageModel data) => json.encode(data.toJson());

class PanoramaImageModel {
  String? imagePath;
  String? collectionId;

  PanoramaImageModel({this.imagePath, this.collectionId});

  factory PanoramaImageModel.fromJson(Map<String, dynamic> json) =>
      PanoramaImageModel(imagePath: json["imagePath"], collectionId: json["collection_id"]);

  Map<String, dynamic> toJson() => {"imagePath": imagePath, "collection_id": collectionId};
}
