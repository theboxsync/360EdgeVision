// To parse this JSON data, do
//
//     final interiorModel = interiorModelFromJson(jsonString);

import 'dart:convert';

InteriorModel interiorModelFromJson(String str) => InteriorModel.fromJson(json.decode(str));

String interiorModelToJson(InteriorModel data) => json.encode(data.toJson());

class InteriorModel {
  List<Collection>? collections;

  InteriorModel({this.collections});

  factory InteriorModel.fromJson(Map<String, dynamic> json) =>
      InteriorModel(collections: List<Collection>.from(json["collections"].map((x) => Collection.fromJson(x))));

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
  int? categoryId;

  ImageDetail({this.id, this.imagePath, this.imageName, this.userId, this.categoryId});

  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
    id: json["id"],
    imagePath: json["image_path"],
    imageName: json["image_name"],
    userId: json["user_id"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {"id": id, "image_path": imagePath, "image_name": imageName, "user_id": userId, "category_id": categoryId};
}
