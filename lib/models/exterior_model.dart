// To parse this JSON data, do
//
//     final exteriorModel = exteriorModelFromJson(jsonString);

import 'dart:convert';

ExteriorModel exteriorModelFromJson(String str) => ExteriorModel.fromJson(json.decode(str));

String exteriorModelToJson(ExteriorModel data) => json.encode(data.toJson());

class ExteriorModel {
  List<Collection>? collections;

  ExteriorModel({this.collections});

  factory ExteriorModel.fromJson(Map<String, dynamic> json) =>
      ExteriorModel(collections: List<Collection>.from(json["collections"].map((x) => Collection.fromJson(x))));

  Map<String, dynamic> toJson() => {"collections": List<dynamic>.from(collections!.map((x) => x.toJson()))};
}

class Collection {
  String? collectionId;
  String? collectionName;
  String? projectName;
  ImageDetail? image;
  String? projectId;

  Collection({this.collectionId, this.collectionName, this.projectName, this.image, this.projectId});

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    collectionId: json["collection_id"],
    collectionName: json["collection_name"],
    projectName: json["project_name"],
    image: ImageDetail.fromJson(json["image"]),
    projectId: json["project_id"],
  );

  Map<String, dynamic> toJson() => {
    "collection_id": collectionId,
    "collection_name": collectionName,
    "project_name": projectName,
    "image": image?.toJson(),
    "project_id": projectId,
  };
}

class ImageDetail {
  String? id;
  String? imagePath;
  String? imageName;
  int? userId;

  ImageDetail({this.id, this.imagePath, this.imageName, this.userId});

  factory ImageDetail.fromJson(Map<String, dynamic> json) =>
      ImageDetail(id: json["id"], imagePath: json["image_path"], imageName: json["image_name"], userId: json["user_id"]);

  Map<String, dynamic> toJson() => {"id": id, "image_path": imagePath, "image_name": imageName, "user_id": userId};
}
